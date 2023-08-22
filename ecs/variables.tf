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

