module "alb_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "5.3.0"
  name                = local.sg_name
  description         = "Security group for the static website ALB"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["10.0.0.0/8"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}
