resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "csr" {
  private_key_pem = tls_private_key.private_key.private_key_pem

  subject {
    common_name         = var.common_name
    organization        = "Avimedical GmbH"
    organizational_unit = "Infrastructure"
    street_address      = ["Ridlerstraße 37-39"]
    locality            = "Munich"
    country             = "DE"
    postal_code         = "80339"
  }
}

resource "cloudflare_origin_ca_certificate" "ca_cert" {
  csr                = tls_cert_request.csr.cert_request_pem
  hostnames          = var.hostnames
  request_type       = "origin-rsa"
  requested_validity = var.validity_days
}
