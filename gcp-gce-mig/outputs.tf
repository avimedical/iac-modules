output "instance_group" {
  value = module.mig.instance_group
}

output "load_balancer_ip" {
  value = module.ilb.ip_address
}
