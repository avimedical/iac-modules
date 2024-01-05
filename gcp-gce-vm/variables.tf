variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for the instance template"
  type        = string
  default     = "default-instance-template"
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to create resources in"
  type        = string
  default     = null
}

variable "hostname" {
  type = string
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "network" {
  description = "The network selflink to host the compute instances in"
}

variable "subnetwork" {
  description = "The subnetwork selflink to host the compute instances in"
}

variable "num_instances" {
  description = "Number of instances to create"
}

variable "nat_ip" {
  description = "Public ip address"
  default     = null
}

variable "network_tier" {
  description = "Network network_tier"
  default     = "PREMIUM"
}

variable "service_account" {
  default = null
  type = object({
    email  = string,
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account."
}

variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = ""
}

variable "source_image_family" {
  description = "Source disk image family. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = "avimedical"
}

variable "disk_encryption_key" {
  description = "The id of the encryption key that is stored in Google Cloud KMS to use to encrypt all the disks on this instance"
  type        = string
  default     = null
}

variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  type        = string
  default     = "n1-standard-1"
}

variable "automatic_restart" {
  type        = bool
  description = "(Optional) Specifies whether the instance should be automatically restarted if it is terminated by Compute Engine (not terminated by a user)."
  default     = true
}

variable "tags" {
  type        = list(string)
  description = "Network tags, provided as a list"
  default     = []
}
