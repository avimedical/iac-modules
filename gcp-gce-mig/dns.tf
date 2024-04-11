locals {
  hostnames = var.dns.create_dns_record && try(module.ilb[0].ip_address, null) != null ? { for idx, hostname in var.dns.create_dns_record : idx => hostname } : {}
}

data "google_dns_managed_zone" "zone" {
  count   = var.dns.create_dns_record ? 1 : 0
  name    = var.dns.zone_name
  project = var.project_id
}

resource "google_dns_record_set" "dns_record" {
  for_each     = local.hostnames
  name         = "${each.value}.${data.google_dns_managed_zone.zone[0].dns_name}"
  type         = "A"
  ttl          = 3600
  managed_zone = data.google_dns_managed_zone.zone[0].name

  rrdatas = [module.ilb[0].ip_address]
}
