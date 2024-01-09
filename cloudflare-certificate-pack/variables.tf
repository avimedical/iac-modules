variable "zone_id" {
  description = "The zone id to create the application in"
  type        = string
}

variable "hosts" {
  description = "The hostnames of the certificate"
  type        = list(string)
  default     = []

}

variable "certificate_authority" {
  description = "The certificate authority to use"
  type        = string
  default     = "google"
}

variable "validity_days" {
  description = "The validity of the certificate in days"
  type        = number
  default     = 90
}
