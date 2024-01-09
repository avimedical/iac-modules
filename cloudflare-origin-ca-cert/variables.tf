variable "common_name" {
  description = "The common name of the certificate"
  type        = string
  default     = ""
}

variable "hostnames" {
  description = "The hostnames of the certificate"
  type        = list(string)
  default     = []
}

variable "validity_days" {
  description = "The validity of the certificate in days"
  type        = number
  default     = 365
}