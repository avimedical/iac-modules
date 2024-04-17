variable "name" {
  type        = string
  description = "Name of the instance"
}

variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
  default     = "gcp-migration-sandbox"
}

variable "zone" {
  description = "The GCP zone to create resources in"
  type        = string
  default     = "europe-west3-a"
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "europe-west3"
}

variable "private_key" {
  description = "Private key"
  type        = string
}

variable "certificate" {
  description = "Certificate"
  type        = string
}

variable "load_balancing_scheme" {
  description = "Load balancing scheme"
  type        = string
  default     = "EXTERNAL"
}


variable "health_check_port" {
  description = "Health check port"
  type        = number
  default     = 80
}

variable "target_backend_group" {
  description = "target group"
  type        = string
  default     = ""
}