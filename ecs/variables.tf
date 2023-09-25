variable "instance_name" {}
variable "image_id" {}
variable "flavor" {}
variable "availability_zone" { default = null }
variable "admin_pass" { default = null }
variable "subnet_id" {}
variable "user_data" { default = null }
variable "key_pair" {}
variable "delete_on_termination" {
  default = true
}
variable "additional_security_group" {
  default = null
}
variable "ecs_volume_size" {}
variable "ecs_volume_type" {}
variable "tags" {}
variable "enable_internal_dns" {}
variable "private_dns_zone_id" {}
variable "internal_dns_record_name" {}
variable "loadbalancer_setup" {
  default = null
  type = object({
    enable            = bool
    subnet_id         = string
    pool_protocol     = string
    pool_method       = string
    listener_protocol = string
    listener_port     = number
    listener_tls_id   = string
    members = list(object({
      address = string
      port    = number
      subnet_id = string
    }))
  })
}