variable "zone_id" {
  description = "The zone id to create the application in"
  type        = string
}

variable "name" {
  description = "The name of the application"
  type        = string
}

variable "value" {
  description = "The value of the dns record"
  type        = string
}

variable "proxied" {
  description = "Whether the dns record is proxied by cloudflare"
  type        = bool
  default     = true
}