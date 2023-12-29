

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 10.0"

  region          = var.region
  project_id      = var.project_id
  subnetwork      = var.subnetwork
  service_account = var.service_account
  disk_encryption_key = var.disk_encryption_key
  machine_type	= var.machine_type
  source_image	= var.source_image
  source_image_family	= ""
  source_image_project = ""
  automatic_restart	= var.automatic_restart
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "~> 10.0"

  region              = var.region
  zone                = var.zone
  subnetwork          = var.subnetwork
  num_instances       = var.num_instances
  hostname            = var.hostname
  instance_template   = module.instance_template.self_link
  deletion_protection = var.deletion_protection

  access_config = [{
    nat_ip       = var.nat_ip
    network_tier = var.network_tier
  }, ]
}