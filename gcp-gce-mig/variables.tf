variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "region" {
  description = "The GCP region where instances will be deployed."
  type        = string
  default     = "europe-west3"
}

variable "zone" {
  description = "The zone where the instance should be created"
  type        = string
  default     = "europe-west3-a"
}


variable "network" {
  description = "The name or self_link of the network to which this instance will be attached"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnet to deploy to. Only one of network or subnetwork should be specified."
  default     = ""
}


variable "named_ports" {
  description = "Named name and named port"
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

####################
# Instance Template
####################

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  default     = "n1-standard-1"
}

variable "spot" {
  description = "Provision a spot instance"
  default     = false
}

variable "can_ip_forward" {
  description = "Enable IP forwarding, for NAT instances for example"
  default     = "false"
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "Labels, provided as a map"
  default     = {}
}

/* disk */
variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = ""
}

variable "source_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  default     = ""
}

variable "source_image_project" {
  description = "Project where the source image comes from"
  default     = ""
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  default     = "20"
}

variable "disk_type" {
  description = "Disk type, can be either pd-ssd, local-ssd, or pd-standard"
  default     = "pd-standard"
}

variable "disk_labels" {
  description = "Labels to be assigned to boot disk, provided as a map"
  default     = { "foo" : "bar" }
}

variable "auto_delete" {
  description = "Whether or not the disk should be auto-deleted"
  default     = "true"
}

variable "additional_disks" {
  description = "List of maps of additional disks. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#disk_name"
  type = list(object({
    disk_name       = string
    device_name     = string
    auto_delete     = bool
    boot            = bool
    disk_size_gb_gb = number
    disk_type       = string
    disk_labels     = map(string)
  }))
  default = []
}

variable "metadata" {
  type        = map(string)
  description = "Metadata, provided as a map"
  default     = {}
}

variable "startup_script" {
  description = "User startup script to run when instances spin up"
  type        = string
  default     = ""
}

variable "service_account" {
  default = null
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account."
}

##########################
# Mananged Instance Group
##########################

variable "hostname" {
  description = "Hostname prefix for instances."
  default     = "default"
}

variable "target_size" {
  description = "The target number of running instances for this managed or unmanaged instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set."
  default     = null
}

variable "target_pools" {
  description = "The target load balancing pools to assign this group to."
  type        = list(string)
  default     = []
}

variable "distribution_policy_zones" {
  description = "The distribution policy, i.e. which zone(s) should instances be create in. Default is all zones in given region."
  type        = list(string)
  default     = []
}

variable "update_policy" {
  description = "The rolling update policy. https://www.terraform.io/docs/providers/google/r/compute_region_instance_group_manager#rolling_update_policy"
  type = list(object({
    max_surge_fixed              = number
    instance_redistribution_type = string
    max_unavailable_fixed        = number
    max_surge_percent            = number
    max_unavailable_percent      = number
    min_ready_sec                = number
    replacement_method           = string
    minimal_action               = string
    type                         = string
  }))
  default = [{
    type                           = "PROACTIVE"
    instance_redistribution_type   = "PROACTIVE"
    minimal_action                 = "REPLACE"
    most_disruptive_allowed_action = "REPLACE"
    max_surge_fixed                = 3
    max_unavailable_fixed          = 0
    max_surge_percent              = null
    max_unavailable_percent        = null
    min_ready_sec                  = 120
    replacement_method             = "SUBSTITUTE"
  }]
}

/* health checks */

variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    type                = string
    initial_delay_sec   = number
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    port                = number
    request             = string
    request_path        = string
    host                = string
    enable_logging      = string
    port_name           = string
  })
  default = {
    type                = "http"
    initial_delay_sec   = 30
    check_interval_sec  = 30
    healthy_threshold   = 1
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 80
    request             = ""
    request_path        = "/"
    host                = ""
    enable_logging      = false
    port_name           = "HTTP"
  }
}

/* autoscaler */

variable "autoscaling_enabled" {
  description = "Creates an autoscaler for the managed instance group"
  type        = bool
  default     = true
}

variable "max_replicas" {
  description = "The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas."
  default     = 1
}

variable "min_replicas" {
  description = "The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0."
  default     = 1
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  default     = 60
}

variable "autoscaling_cpu" {
  description = "Autoscaling, cpu utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#cpu_utilization"
  type        = list(map(number))
  default     = []
}

variable "autoscaling_metric" {
  description = "Autoscaling, metric policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#metric"
  type = list(object({
    name   = string
    target = number
    type   = string
  }))
  default = []
}

variable "autoscaling_lb" {
  description = "Autoscaling, load balancing utilization policy block as single element array. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#load_balancing_utilization"
  type        = list(map(number))
  default     = []
}

variable "autoscaling_scale_in_control" {
  description = "Autoscaling, scale-in control block. https://www.terraform.io/docs/providers/google/r/compute_autoscaler#scale_in_control"
  type = object({
    fixed_replicas   = number
    percent_replicas = number
    time_window_sec  = number
  })
  default = {
    fixed_replicas   = 0
    percent_replicas = 30
    time_window_sec  = 600
  }
}

variable "disk_encryption_key" {
  description = "The self link to the encryption key that's used to encrypt the disk"
  type        = string
  default     = ""
}

variable "automatic_restart" {
  description = "Specifies whether the instance should be automatically restarted if it is terminated by Compute Engine"
  type        = bool
  default     = true
}

variable "num_instances" {
  description = "The number of instances to create"
  type        = number
  default     = 1
}

variable "deletion_protection" {
  description = "Whether the resource should be protected against deletion"
  type        = bool
  default     = false
}

variable "name_prefix" {
  description = "The prefix for the names of the instances"
  type        = string
}


variable "ilb_enabled" {
  description = "Creates an internal load balancer for the managed instance group"
  type        = bool
  default     = false
}

variable "ilb_source_tags" {
  description = "Source tags to be used by the internal load balancer"
  type        = list(string)
  default     = []
}

variable "allow_ssh" {
  description = "Create firewall rule for SSH access"
  type        = bool
  default     = false
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
