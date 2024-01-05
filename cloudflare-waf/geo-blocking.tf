
resource "cloudflare_filter" "manage_challenge_ips_from_countries" {
  count       = var.enable_geoblocking && var.geoblock_manage_challenge_expression == true ? 1 : 0
  zone_id     = var.zone_id
  description = "manage challenge IPs from different countries"
  expression  = var.geoblock_manage_challenge_expression
}

resource "cloudflare_filter" "allow_ips_from_countries" {
  count       = var.enable_geoblocking && var.geoblock_allow_expression == true ? 1 : 0
  zone_id     = var.zone_id
  description = "Allow IPs from different countries"
  expression  = var.geoblock_allow_expression
}

resource "cloudflare_filter" "block_ips_from_countries" {
  count       = var.enable_geoblocking && var.geoblock_block_expression == true ? 1 : 0
  zone_id     = var.zone_id
  description = "Block IPs from different countries"
  expression  = var.geoblock_block_expression
}
resource "cloudflare_firewall_rule" "manage_challenge_ips_from_countries" {
  count       = var.enable_geoblocking && var.geoblock_manage_challenge_expression == true ? 1 : 0
  zone_id     = var.zone_id
  description = "Manage challege for countries"
  filter_id   = cloudflare_filter.manage_challenge_ips_from_countries[0].id
  action      = "managed_challenge"
  priority    = 2
}


resource "cloudflare_firewall_rule" "allow_ips_from_countries" {
  count       = var.enable_geoblocking && var.geoblock_allow_expression == true ? 1 : 0
  zone_id     = var.zone_id
  description = "Allow IPs from Any country thats not Germany"
  filter_id   = cloudflare_filter.allow_ips_from_countries[0].id
  action      = "allow"
  priority    = 2
}

resource "cloudflare_firewall_rule" "block_ips_from_countries" {
  count       = var.enable_geoblocking && var.geoblock_block_expression == true ? 1 : 0
  zone_id     = var.zone_id
  description = "Block IPs from Any country thats not Germany"
  filter_id   = cloudflare_filter.block_ips_from_countries[0].id
  action      = "block"
  priority    = 2
}
