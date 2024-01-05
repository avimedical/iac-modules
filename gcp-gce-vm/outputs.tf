output "instances_self_links" {
  description = "List of self-links for compute instances"
  value       = module.compute_instance.instances_self_links
}

output "available_zones" {
  description = "List of available zones in region"
  value       = module.compute_instance.available_zones
}

outout "instances_details" {
  description = "IP address of the instance"
  value       = module.compute_instance.instances_details
}