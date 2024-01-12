
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
  # master_ipv4_cidr_block            = var.master_ipv4_cidr_block
  network_policy                    = true
  horizontal_pod_autoscaling        = true
  service_account                   = "create"
  remove_default_node_pool          = true
  disable_legacy_metadata_endpoints = true
  deletion_protection               = var.deletion_protection
  deploy_using_private_endpoint     = true
  enable_shielded_nodes             = true
  enable_vertical_pod_autoscaling   = var.enable_vertical_pod_autoscaling
  config_connector                  = var.config_connector
  cluster_autoscaling               = var.cluster_autoscaling

  node_pools = var.node_pools_config
  # node_pools_oauth_scopes = {
  #   for pool_config in var.node_pools_config :
  #   pool_config.name => pool_config.node_pools_oauth_scopes
  # }

  # node_pools_labels = {
  #   for  pool_config in var.node_pools_config :
  #   pool_config.name => pool_config.node_pools_labels
  # }

  # node_pools_metadata = {
  #   for  pool_config in var.node_pools_config :
  #   pool_config.name => pool_config.node_pools_metadata
  # }

  # node_pools_tags = {
  #   for  pool_config in var.node_pools_config :
  #   pool_config.name => pool_config.node_pools_tags
  # }
}