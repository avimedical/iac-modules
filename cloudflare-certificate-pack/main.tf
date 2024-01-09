resource "cloudflare_certificate_pack" "tls_root_cert" {
  zone_id               = var.zone_id
  type                  = "advanced"
  hosts                 = var.hosts
  validation_method     = "txt"
  validity_days         = var.validity_days
  certificate_authority = var.certificate_authority
  cloudflare_branding   = false
}

