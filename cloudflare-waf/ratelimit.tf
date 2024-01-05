resource "cloudflare_ruleset" "zone_rl" {
  zone_id     = var.zone_id
  name        = "Zone Ratelimiting"
  description = "Zone level ratelimiting"
  kind        = "zone"
  phase       = "http_ratelimit"

  dynamic "rules" {
    for_each = var.ratelimit_config

    content {
      action = rules.value.action
      ratelimit {
        characteristics     = ["cf.colo.id", "ip.src"]
        period              = rules.value.period
        requests_per_period = rules.value.requests_per_period
        mitigation_timeout  = 60
      }
      expression  = rules.value.expression
      description = rules.value.description
      enabled     = true
    }
  }
}