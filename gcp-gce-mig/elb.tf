module "elb_ca_cert" {
  count       = var.elb_enabled == true ? 1 : 0
  source      = "git::git@github.com:avimedical/iac-modules.git//cloudflare-origin-ca-cert"
  common_name = var.external_hostname
  hostnames   = [var.external_hostname]
}

resource "google_compute_ssl_certificate" "ssl_cert" {
  count       = var.elb_enabled == true ? 1 : 0
  name        = "${var.name_prefix}-cert"
  private_key = module.vault_ca_cert.private_key_pem
  certificate = module.vault_ca_cert.cert
}


module "gce-lb-http" {
  count             = var.elb_enabled == true ? 1 : 0
  source            = "terraform-google-modules/lb-http/google"
  version           = "~> 10.0"
  name              = "${var.name_prefix}-https-redirect"
  project           = var.project_id
  target_tags       = var.tags
  firewall_networks = [var.network]
  ssl               = true
  ssl_certificates  = [google_compute_ssl_certificate.ssl_cert.self_link]
  https_redirect    = true

  backends = [{
    group       = module.mig.instance_group
    description = ""
    failover    = false
  }]

  health_check = merge(
    var.health_check,
    { enable_log = var.health_check.enable_logging }
  )
}

