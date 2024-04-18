variable "project_id" {
  description = "Project ID"
}
variable "cluster_name" {
  description = "Cluster name"
}
variable "region" {
  description = "Region"
}

variable "zones" {
  type        = list(string)
  description = "The zone to host the cluster in (required if is a zonal cluster)"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.28.3-gke.1286000"
}

variable "network_name" {
  description = "Network name"
}
variable "subnetwork_name" {
  description = "Subnetwork name"
}

variable "ip_range_pods" {
  default = "pod-ip-range"
}

variable "ip_range_services" {
  default = "service-ip-range"
}
variable "deletion_protection" {
  description = "Deletion protection"
  default     = false
}
variable "enable_vertical_pod_autoscaling" {
  description = "Enable vertical pod autoscaling"
  default     = false
}
variable "database_encryption" {
  description = "Application-layer Secrets Encryption settings. The object format is {state = string, key_name = string}. Valid values of state are: \"ENCRYPTED\"; \"DECRYPTED\". key_name is the name of a CloudKMS key."
  type        = list(object({ state = string, key_name = string }))

  default = [{
    state    = "DECRYPTED"
    key_name = ""
  }]
}
variable "cluster_autoscaling" {
  type = object({
    enabled       = bool
    # autoscaling_profile = string
    min_cpu_cores = number
    max_cpu_cores = number
    min_memory_gb = number
    max_memory_gb = number
    gpu_resources = list(object({ resource_type = string, minimum = number, maximum = number }))
    auto_repair   = bool
    auto_upgrade  = bool
    disk_size     = optional(number)
    disk_type     = optional(string)
  })
  default = {
    enabled       = false
    # autoscaling_profile = "BALANCED"
    max_cpu_cores = 0
    min_cpu_cores = 0
    max_memory_gb = 0
    min_memory_gb = 0
    gpu_resources = []
    auto_repair   = true
    auto_upgrade  = true
    disk_size     = 100
    disk_type     = "pd-standard"
  }
  description = "Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling)"
}

variable "node_pools_config" {
  description = "Node pools configuration"
  type        = list(map(any))
}

variable "node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node-pool name"
}

variable "node_pools_tags" {
  type        = map(list(string))
  description = "Map of lists containing node network tags by node-pool name"

}

variable "node_pools_oauth_scopes" {
  type        = map(list(string))
  description = "Map of lists containing node oauth scopes by node-pool name"
}

variable "node_pools_metadata" {
  type        = map(map(string))
  description = "Map of maps containing node metadata by node-pool name"
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node-pool name"
}
variable "config_connector" {
  type        = bool
  description = "Whether ConfigConnector is enabled for this cluster."
  default     = true
}

variable "enable_private_endpoint" {
  type        = bool
  description = "Whether to enable private endpoint on the cluster."
  default     = false
}

# variable "authenticator_security_group" {
#   type        = string
#   description = "The security group to use for authenticator access."
#   default     = ""
# }


variable "deploy_using_private_endpoint" {
  type        = bool
  description = "Whether to deploy using private endpoint."
  default     = false
}

variable "remove_default_node_pool" {
  default = true
}

variable "dns" {
  description = "DNS configuration"
  type = object({
    create_dns_record = bool
    zone_name         = optional(string)
    hostnames         = optional(list(string))
  })
  default = {
    create_dns_record = false
  }
}
