variable "environment" {
  description = "The AVI system environment"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prod"], var.domain)
    error_message = "The domain must be one of 'dev', 'stg', 'prod'"
  }
}

variable "domain" {
  description = "The AVI system domain"
  type        = string
  validation {
    condition     = contains(["int", "sha", "ber", "mun", "ham", "stu"], var.domain)
    error_message = "The domain must be one of 'int', 'sha', 'ber', 'mun', 'ham', 'stu'"
  }
}

variable "resource_type" {
  description = "The type of GCP resource"
  type        = string
  default     = null
}

variable "resource_name" {
  description = "The name of the resource"
  type        = string
  default     = null
}

variable "resource_iteration" {
  description = "The iteration number of this resource. Defaults to 1."
  type        = number
  default     = 1
}