# ecs Loadbalancing 
resource "opentelekomcloud_lb_loadbalancer_v2" "ecs_loadbalancer" {
  count         = var.loadbalancer_setup.enable == true ? 1 : 0
  name          = "${var.instance_name}-elb"
  vip_subnet_id = var.loadbalancer_setup.subnet_id
}

resource "opentelekomcloud_networking_floatingip_v2" "ecs_loadbalancer_ip" {
  count         = var.loadbalancer_setup.enable == true ? 1 : 0
  port_id = opentelekomcloud_lb_loadbalancer_v2.ecs_loadbalancer.vip_port_id
}


resource "opentelekomcloud_lb_listener_v2" "ecs_loadbalancer_listener" {
  name                      = "${var.instance_name}-listener"
  loadbalancer_id           = opentelekomcloud_lb_loadbalancer_v2.ecs_loadbalancer.id
  protocol                  = var.loadbalancer_setup.listener_protocol
  protocol_port             = var.loadbalancer_setup.listener_port
  default_tls_container_ref = var.loadbalancer_setup.listener_tls_id
}

resource "opentelekomcloud_lb_pool_v2" "ecs_loadbalancer_pool" {
  name        = "${var.instance_name}-pool"
  protocol    = var.loadbalancer_setup.pool_protocol
  listener_id = opentelekomcloud_lb_listener_v2.ecs_loadbalancer_listener.id
  lb_method   = var.loadbalancer_setup.pool_method
}

resource "opentelekomcloud_lb_member_v2" "ecs_loadbalancer_pool_members" {
  address       = module.ecs.network_ipv4
  protocol_port = 8200
  pool_id       = opentelekomcloud_lb_pool_v2.ecs_loadbalancer_pool.id
  subnet_id     = data.opentelekomcloud_vpc_subnet_v1.private_subnet_v1.subnet_id
}

resource "opentelekomcloud_dns_recordset_v2" "ecs_dns_private" {
  count = var.enable_internal_dns == true ?  1 : 0
  zone_id     = data.opentelekomcloud_dns_zone_v2.private_dns_zone.id
  name        = "${var.dns_prefix}.${var.dns_zone_name}"
  description = "${var.instance_name} private DNS record"
  ttl         = 300
  type        = "A"
  records     =  var.loadbalancer_setup.enable == true ? [opentelekomcloud_lb_loadbalancer_v2.ecs_loadbalancer.vip_address] : [module.ecs.network_ipv4]
}
