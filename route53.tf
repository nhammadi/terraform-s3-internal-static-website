resource "aws_route53_zone" "website_zone" {
  name = local.private_zone_name
  vpc {
    vpc_id = data.aws_vpc.main_vpc.id
  }
}

resource "aws_route53_record" "website_alb_record" {
  zone_id = aws_route53_zone.website_zone.zone_id
  name    = local.private_zone_name
  type    = "A"
  alias {
    name                   = aws_lb.website_alb.dns_name
    zone_id                = aws_lb.website_alb.zone_id
    evaluate_target_health = true
  }
}
