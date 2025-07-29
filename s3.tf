module "website_bucket" {
  source                                = "terraform-aws-modules/s3-bucket/aws"
  version                               = "5.2.0"
  bucket                                = local.private_zone_name
  attach_policy                         = true
  block_public_policy                   = true
  block_public_acls                     = true
  restrict_public_buckets               = true
  ignore_public_acls                    = true
  attach_deny_insecure_transport_policy = true
  force_destroy                         = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "vpceAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          module.website_bucket.s3_bucket_arn,
          "${module.website_bucket.s3_bucket_arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpce" : data.aws_vpc_endpoint.s3_interface_endpoint.id
          }
        }
      }
    ]
  })
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
