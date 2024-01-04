variable "name" {
  type        = string
  description = "Name of the instance"
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "eu-west4"
}

variable "instances" {
  description = "List of instances for target pool"
  default     = []
}

variable "load_balancing_scheme" {
  description = "Load balancing scheme"
  type        = string
  default     = "EXTERNAL"
}

variable "target_port" {
  description = "Target port"
  type        = number
  default     = 80
}

variable "enable_health_check" {
  description = "Enable health check"
  type        = bool
  default     = true
}


