resource "aws_lb" "website_alb" {
  name                       = local.alb_name
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [module.alb_sg.security_group_id]
  subnets                    = var.private_subnet_ids
  drop_invalid_header_fields = true
  enable_xff_client_port     = true
}

resource "aws_lb_listener" "default_lb_listener" {
  load_balancer_arn = aws_lb.website_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.internal_cert.arn
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code  = "503"
    }
  }
}

resource "aws_lb_target_group" "vpce_lb_target_group" {
  name        = local.alb_target_group_name
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = data.aws_vpc.main_vpc.id
  health_check {
    port     = 80
    protocol = "HTTP"
    matcher  = "200,307,405"
  }
}

resource "aws_lb_target_group_attachment" "vpce_lb_target_group_attachment" {
  for_each         = toset(var.s3_vpc_endpoint_ips)
  target_group_arn = aws_lb_target_group.vpce_lb_target_group.arn
  target_id        = each.key
  port             = 443
}

resource "aws_lb_listener_rule" "default_lb_listener_rule_1" {
  listener_arn = aws_lb_listener.default_lb_listener.arn
  priority     = 1
  action {
    type = "redirect"

    redirect {
      port        = "#{port}"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "#{host}"
      path        = "/#{path}index.html"
      query       = "#{query}"
    }
  }

  condition {
    path_pattern {
      values = ["*/"]
    }
  }

  condition {
    host_header {
      values = [local.private_zone_name]
    }
  }
}

resource "aws_lb_listener_rule" "default_lb_listener_rule_2" {
  listener_arn = aws_lb_listener.default_lb_listener.arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vpce_lb_target_group.arn
  }
  condition {
    host_header {
      values = [local.private_zone_name]
    }
  }
}
