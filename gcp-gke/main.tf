
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 29.0"

  project_id                        = var.project_id
  name                              = var.cluster_name
  region                            = var.region
  regional                          = true
  network                           = var.network_name
  subnetwork                        = var.subnetwork_name
  ip_range_pods                     = var.ip_range_pods
  ip_range_services                 = var.ip_range_services
  enable_private_endpoint           = true
  enable_private_nodes              = true
  master_ipv4_cidr_block            = var.master_ipv4_cidr_block
  network_policy                    = true
  horizontal_pod_autoscaling        = true
  service_account                   = "create"
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true
  deletion_protection               = var.deletion_protection
  # cluster_autoscaling               = var.cluster_autoscaling
  database_encryption               = var.database_encryption
  deploy_using_private_endpoint     = true
  enable_shielded_nodes             = true
  enable_vertical_pod_autoscaling   = var.enable_vertical_pod_autoscaling
  config_connector                  = var.config_connector

  node_pools = [
    for pool_name, pool_config in var.node_pools_config : {
      name               = pool_config.name
      machine_type       = pool_config.machine_type
      min_count          = pool_config.min_count
      max_count          = pool_config.max_count
      disk_size_gb       = pool_config.disk_size_gb
      disk_type          = pool_config.disk_type
      auto_repair        = pool_config.auto_repair
      auto_upgrade       = pool_config.auto_upgrade
      preemptible        = pool_config.preemptible
      initial_node_count = pool_config.initial_node_count
      auto_repair        = pool_config.auto_repair
      auto_upgrade       = pool_config.auto_upgrade
      autoscaling        = pool_config.autoscaling
    }
  ]

  node_pools_oauth_scopes = {
    for pool_name, pool_config in var.node_pools_config :
    pool_name => pool_config.node_pools_oauth_scopes
  }

  node_pools_labels = {
    for pool_name, pool_config in var.node_pools_config :
    pool_name => pool_config.node_pools_labels
  }

  node_pools_metadata = {
    for pool_name, pool_config in var.node_pools_config :
    pool_name => pool_config.node_pools_metadata
  }

  node_pools_tags = {
    for pool_name, pool_config in var.node_pools_config :
    pool_name => pool_config.node_pools_tags
  }
}