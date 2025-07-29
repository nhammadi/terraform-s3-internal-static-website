variable "region" {
  type        = string
  description = "Default AWS region"
  default     = "eu-west-1"
}

variable "vpc_id" {
  type        = string
  description = "VPC id where all th erequired resources will be provisioned"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "s3_vpc_endpoint_ips" {
  description = "List of IPs assigned to the S3 vpc interface endpoint"
  type        = list(string)
}
