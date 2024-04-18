
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version = "~> 29.0"

  project_id          = var.project_id
  name                = var.cluster_name
  region              = var.region
  regional            = false
  zones               = var.zones
  network             = var.network_name
  subnetwork          = var.subnetwork_name
  kubernetes_version  = var.kubernetes_version
  database_encryption = var.database_encryption
  //dedicated Secondary IP range for pods
  ip_range_pods = var.ip_range_pods
  //dedicated Secondary IP range for services
  ip_range_services = var.ip_range_services

  enable_private_endpoint           = var.enable_private_endpoint
  enable_private_nodes              = true
  network_policy                    = true
  horizontal_pod_autoscaling        = true
  service_account                   = "create"
  remove_default_node_pool          = var.remove_default_node_pool
  disable_legacy_metadata_endpoints = true
  deletion_protection               = var.deletion_protection
  deploy_using_private_endpoint     = var.deploy_using_private_endpoint
  enable_shielded_nodes             = true
  enable_vertical_pod_autoscaling   = var.enable_vertical_pod_autoscaling
  config_connector                  = var.config_connector
  cluster_autoscaling               = var.cluster_autoscaling
  master_authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "${var.cluster_name}-vpc"
    },
  ]

  node_pools              = var.node_pools_config
  node_pools_oauth_scopes = var.node_pools_oauth_scopes
  node_pools_labels       = var.node_pools_labels
  node_pools_metadata     = var.node_pools_metadata
  node_pools_tags         = var.node_pools_tags
}