variable "zone_id" {
  description = "The zone id to create the application in"
  type        = string
}
variable "name" {
  description = "The name of the application"
  type        = string
}   
variable "domain" {
  description = "The domain of the application"
  type        = string
}
variable "type" {
  description = "The type of the application"
  type        = string
  default     = "A"
  }
variable "allowed_idps" {
  description = "The allowed idps of the application"
  type        = list(string)
}
