variable "project_id" {
  description = "Project ID"
}
variable "cluster_name" {
  description = "Cluster name"
}
variable "region" {
  description = "Region"
}
variable "network_name" {
  description = "Network name"
}
variable "subnetwork_name" {
  description = "Subnetwork name"
}
variable "ip_range_pods" {
  description = "IP range pods"
}
variable "ip_range_services" {
  description = "IP range services"
}
variable "master_ipv4_cidr_block" {
  description = "Master ipv4 cidr block"
}
variable "deletion_protection" {
  description = "Deletion protection"
  default     = false
}

variable "database_encryption" {
  description = "Database encryption"
  default     = false
}
variable "enable_vertical_pod_autoscaling" {
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
  type = list(object({
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
    }))
    node_pools_taints       = list(object({ key = string, value = string, effect = string }))
    node_pools_oauth_scopes = list(string)
    node_pools_labels       = map(string)
    node_pools_metadata     = map(string)
    node_pools_tags         = list(string)
    # Add more keys as needed
  }))
}

variable "config_connector" {
  type        = bool
  description = "Whether ConfigConnector is enabled for this cluster."
  default     = true
}