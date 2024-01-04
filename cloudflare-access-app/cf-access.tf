resource "cloudflare_access_application" "app" {
  zone_id          = var.zone_id
  name             = var.name
  domain           = var.domain
  type             = var.type
  session_duration = "24h"
  allowed_idps     = var.allowed_idps
  tags             = var.tags
}