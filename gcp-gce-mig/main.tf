
module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 10.0"

  name_prefix          = var.name_prefix
  region               = var.region
  project_id           = var.project_id
  subnetwork           = var.subnetwork
  service_account      = var.service_account
  disk_encryption_key  = var.disk_encryption_key
  machine_type         = var.machine_type
  source_image         = var.source_image
  source_image_family  = var.source_image_family
  source_image_project = var.project_id
  automatic_restart    = var.automatic_restart
  startup_script       = var.startup_script
  tags                 = var.tags
}

module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 10.0"

  project_id                = var.project_id
  hostname                  = var.hostname
  region                    = var.region
  instance_template         = module.instance_template.self_link
  target_size               = var.target_size
  target_pools              = var.target_pools
  distribution_policy_zones = var.distribution_policy_zones
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
  count       = var.ilb_enabled == true ? 1 : 0 

  source      = "GoogleCloudPlatform/lb-internal/google"
  version     = "~> 5.0"
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
