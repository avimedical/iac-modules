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
  default     = "europe-west4-a"
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "eu-west4"
}

variable "network" {
  description = "The network selflink to host the compute instances in"
}

variable "subnetwork" {
  description = "The subnetwork selflink to host the compute instances in"
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "target_ip" {
  description = "target IP"
  type        = string
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

variable "target_port" {
  description = "Target port"
  type        = number
  default     = 80
}

