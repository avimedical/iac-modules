varible "project_id" {
  description = "Project ID"
}
varible "cluster_name" {
  description = "Cluster name"
}
varible "region" {
  description = "Region"
}
varible "network_name" {
  description = "Network name"
}
varible "subnetwork_name" {
  description = "Subnetwork name"
}
varible "ip_range_pods" {
  description = "IP range pods"
}
varible "ip_range_services" {
  description = "IP range services"
}
varible "master_ipv4_cidr_block" {
  description = "Master ipv4 cidr block"
}
varible "deletion_protection" {
  description = "Deletion protection"
  default     = false
}

varible "database_encryption" {
  description = "Database encryption"
  default     = false
}
varible "enable_vertical_pod_autoscaling" {
  description = "Enable vertical pod autoscaling"
  default     = false
}

# variable "cluster_autoscaling" {
#   type = object({
#     enabled       = bool
#     min_cpu_cores = number
#     max_cpu_cores = number
#     min_memory_gb = number
#     max_memory_gb = number
#     gpu_resources = list(object({ resource_type = string, minimum = number, maximum = number }))
#     auto_repair   = bool
#     auto_upgrade  = bool
#     disk_size     = optional(number)
#     disk_type     = optional(string)
#   })
#   default = {
#     enabled       = false
#     max_cpu_cores = 0
#     min_cpu_cores = 0
#     max_memory_gb = 0
#     min_memory_gb = 0
#     gpu_resources = []
#     auto_repair   = true
#     auto_upgrade  = true
#     disk_size     = 100
#     disk_type     = "pd-standard"
#   }
#   description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
# }


variable "node_pools_config" {
  description = "Node pools configuration"
  type = map(object({
    name                    = string
    machine_type            = string
    min_count               = number
    max_count               = number
    disk_size_gb            = number
    disk_type               = string
    auto_repair             = bool
    auto_upgrade            = bool
    preemptible             = bool
    initial_node_count      = number
    autoscaling             = optional(object({
      enabled       = bool
      min_count = number
      max_count = number
      total_min_count = number
      total_max_count = number
      location_policy = string
    }))
    node_pools_taints       = list(object({ key = string, value = string, effect = string }))
    node_pools_oauth_scopes = list(string)
    node_pools_labels       = map(string)
    node_pools_metadata     = map(string)
    node_pools_tags         = list(string)
    # Add more keys as needed
  }))
  default = {
    my_node_pool = {
      name               = "my-node-pool"
      machine_type       = "n1-standard-1"
      min_count          = 1
      max_count          = 1
      disk_size_gb       = 100
      disk_type          = "pd-ssd"
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = false
      initial_node_count = 1
      additional_key1    = "value1"
      additional_key2    = "value2"
    }
    # Add more entries as needed
  }
}

variable "config_connector" {
  type        = bool
  description = "Whether ConfigConnector is enabled for this cluster."
  default     = true
}