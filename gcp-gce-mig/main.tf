
module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 13.2"

  name_prefix          = var.name_prefix
  region               = var.region
  project_id           = var.project_id
  subnetwork           = var.subnetwork
  service_account      = var.service_account
  create_service_account = false
  disk_encryption_key  = var.disk_encryption_key
  disk_type            = var.disk_type
  disk_size_gb         = var.disk_size_gb
  machine_type         = var.machine_type
  source_image         = var.source_image
  source_image_family  = var.source_image_family
  source_image_project = var.project_id
  automatic_restart    = var.automatic_restart
  startup_script       = var.startup_script
  spot                 = var.spot
  tags                 = var.tags
  labels               = var.labels
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 13.2"

  project_id                = var.project_id
  hostname                  = var.hostname
  region                    = var.region
  distribution_policy_zones = var.distribution_policy_zones
  instance_template         = module.instance_template.self_link
  target_size               = var.target_size
  target_pools              = var.target_pools
  update_policy             = var.update_policy
  named_ports               = var.named_ports

  /* health check */
  health_check = var.health_check

  /* autoscaler */
  autoscaling_enabled          = var.autoscaling_enabled
  max_replicas                 = var.max_replicas
  min_replicas                 = var.min_replicas
  cooldown_period              = var.cooldown_period
  autoscaling_cpu              = var.autoscaling_cpu
  autoscaling_metric           = var.autoscaling_metric
  autoscaling_lb               = var.autoscaling_lb
  autoscaling_scale_in_control = var.autoscaling_scale_in_control
}

module "ilb" {
  count = var.ilb_enabled == true ? 1 : 0

  source      = "GoogleCloudPlatform/lb-internal/google"
  version     = "~> 7.0"
  project     = var.project_id
  network     = var.network
  subnetwork  = var.subnetwork
  region      = var.region
  name        = "${var.name_prefix}-ilb"
  ports       = [var.health_check.port]
  source_tags = var.ilb_source_tags
  target_tags = var.tags

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

resource "google_compute_firewall" "allow_health_check" {
  name    = "${var.name_prefix}-allow-health-check"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = [var.health_check.port]
  }

  source_ranges = [
    # Health check probe IP ranges, see https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
  target_tags   = var.tags
}

resource "google_compute_firewall" "allow_ssh" {
  count = var.allow_ssh == true ? 1 : 0

  name    = "${var.name_prefix}-allow-ssh"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "35.235.240.0/20" #  IAP TCP forwarding IP range
  ]
  target_tags   = var.tags
}
