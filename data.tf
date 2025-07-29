data "aws_vpc" "main_vpc" {
  id = var.vpc_id
}

data "aws_vpc_endpoint" "s3_interface_endpoint" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  filter {
    name   = "vpc-endpoint-type"
    values = ["Interface"]
  }
}
