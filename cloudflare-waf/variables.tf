variable "zone_id" {
  description = "The zone id to create the application in"
  type        = string
}

variable "enable_geoblocking" {
  description = "Enable geoblocking"
  default     = true
}

variable "enable_waf_managed_ruleset" {
  description = "Enable WAF managed ruleset"
  default     = true
}

variable "geoblock_allow_expression" {
  description = "The expression to allow traffic from"
  default     = false
}

variable "geoblock_block_expression" {
  description = "The expression to block traffic from"
  default     = false

}
variable "geoblock_manage_challenge_expression" {
  description = "The expression to manage challenge traffic from"
  default     = false
}

variable "ratelimit_config" {
  description = "Rate limiting configuration"
  type = list(object({
    action              = string
    expression          = string
    description         = string
    period              = number
    requests_per_period = number
  }))
  default = [
    {
      action              = "block"
      expression          = "(http.request.uri.path matches \"^/api/\")"
      description         = "Zone level rate limiting rule"
      period              = 60
      requests_per_period = 600
    }
  ]
}

variable "managed_waf_override_config" {
  description = "Managed WAF override configuration"
  type = list(object({
    category = string
    action   = string
    status   = string
  }))
  default = [
    {
      category = "adobe-flash"
      action   = "block"
      status   = "enabled"
    }
  ]
}