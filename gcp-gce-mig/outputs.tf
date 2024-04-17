output "instance_group" {
  value = module.mig.instance_group
}

output "load_balancer_ip" {
  value = try(module.ilb[0].ip_address, null)
}

output "external_load_balancer_ip" {
  value = try(module.gce-lb-http.external_ip, null)
}

