variable "node_pools_config" {
  type = map(object({
    name               = string
    machine_type       = string
    min_count          = number
    max_count          = number
    disk_size_gb       = number
    disk_type          = string
    auto_repair        = bool
    auto_upgrade       = bool
    preemptible        = bool
    initial_node_count = number
    node_pools_oauth_scopes = map(list(string)) 
    node_pools_labels = map(map(string))
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
