locals {
  private_zone_name     = "app.internal.examplecorp.local"
  alb_name              = "website-alb"
  alb_target_group_name = "${local.alb_name}-target-group"
  sg_name               = "${local.alb_name}-sg"
}
