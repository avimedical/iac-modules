resource "cloudflare_record" "cf_dns_record" {
  zone_id         = var.zone_id
  name            = var.name
  value           = var.value
  type            = "A"
  allow_overwrite = true
  ttl             = 1
  proxied         = var.proxied
}
