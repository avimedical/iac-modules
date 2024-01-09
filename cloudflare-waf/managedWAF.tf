# Zone-level WAF Managed Ruleset
resource "cloudflare_ruleset" "zone_level_managed_waf_with_category_based_overrides" {
  count       = var.enable_waf_managed_ruleset == true ? 1 : 0
  zone_id     = var.zone_id
  name        = "managed WAF"
  description = "managed WAF ruleset description"
  kind        = "zone"
  phase       = "http_request_firewall_managed"

  # Execute Cloudflare Managed Ruleset
  rules {
    action = "execute"
    action_parameters {
      id = "efb7b8c949ac4650a09736fc376e9aee"
      overrides {
        dynamic "categories" {
          for_each = var.managed_waf_override_config
          content {
            category = categories.value.category
            action   = categories.value.action
            status   = categories.value.status
          }
        }
      }
    }
    expression  = "true"
    description = "Execute Cloudflare Managed Ruleset on zone-level phase entry point ruleset"
    enabled     = false
  }

  # # Execute Cloudflare OWASP Core Ruleset
  rules {
    action = "execute"
    action_parameters {
      id = "4814384a9e5d4991b9815dcfc25d2f1f"
      overrides {
        rules {
          id     = "6179ae15870a4bb7b2d480d4843b323c"
          action = "managed_challenge"
        }
      }
    }
    expression  = "true"
    description = "Execute Cloudflare OWASP Core Ruleset on zone-level phase entry point ruleset"
    enabled     = false
  }
}