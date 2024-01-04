resource "cloudflare_access_application" "app" {
  zone_id          = var.zone_id
  name             = var.name
  domain           = var.domain
  type             = var.type
  session_duration = "24h"
  allowed_idps     = var.allowed_idps
}

resource "cloudflare_access_policy" "cf_policy" {
  application_id = cloudflare_access_application.app.id
  zone_id        = var.zone_id
  name           = var.name
  precedence     = "1"
  decision       = "allow"

  include {
    group = var.allowed_groupids
  }
}