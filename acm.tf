resource "tls_private_key" "internal_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "internal_cert" {
  private_key_pem = tls_private_key.internal_key.private_key_pem
  subject {
    common_name  = local.private_zone_name
    organization = "Example, Corp"
  }
  validity_period_hours = 8760 # 1 year
  is_ca_certificate     = false

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = [
    local.private_zone_name
  ]
}

resource "aws_acm_certificate" "internal_cert" {
  private_key       = tls_private_key.internal_key.private_key_pem
  certificate_body  = tls_self_signed_cert.internal_cert.cert_pem
  certificate_chain = tls_self_signed_cert.internal_cert.cert_pem
}
