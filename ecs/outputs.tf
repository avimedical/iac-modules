output "network_ipv4" {
  value = opentelekomcloud_compute_instance_v2.this.access_ip_v4
}

output "loadbalancer_id" {
  count         = var.loadbalancer_setup.enable == true ? 1 : 0
  value = opentelekomcloud_lb_loadbalancer_v2.ecs_loadbalancer[0].vip_port_id
}