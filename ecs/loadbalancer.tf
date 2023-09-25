# ecs Loadbalancing 
resource "opentelekomcloud_lb_loadbalancer_v2" "ecs_loadbalancer" {
  count         = var.loadbalancer_setup.enable == true ? 1 : 0
  name          = "${var.instance_name}-elb"
  vip_subnet_id = var.loadbalancer_setup.subnet_id

  depends_on = [ opentelekomcloud_compute_instance_v2.this ]
}

resource "opentelekomcloud_lb_listener_v2" "ecs_loadbalancer_listener" {
  
  count         = var.loadbalancer_setup.enable == true ? 1 : 0

  name                      = "${var.instance_name}-listener"
  loadbalancer_id           = opentelekomcloud_lb_loadbalancer_v2.ecs_loadbalancer[0].id
  protocol                  = var.loadbalancer_setup.listener_protocol
  protocol_port             = var.loadbalancer_setup.listener_port
  default_tls_container_ref = var.loadbalancer_setup.listener_tls_id

  depends_on = [ opentelekomcloud_lb_loadbalancer_v2.ecs_loadbalancer[0] ]
}

resource "opentelekomcloud_lb_pool_v2" "ecs_loadbalancer_pool" {
    count         = var.loadbalancer_setup.enable == true ? 1 : 0

  name        = "${var.instance_name}-pool"
  protocol    = var.loadbalancer_setup.pool_protocol
  listener_id = opentelekomcloud_lb_listener_v2.ecs_loadbalancer_listener[0].id
  lb_method   = var.loadbalancer_setup.pool_method

  depends_on = [ opentelekomcloud_lb_listener_v2.ecs_loadbalancer_listener[0] ]
}

resource "opentelekomcloud_lb_member_v2" "ecs_loadbalancer_pool_members" {
  
  for_each = var.loadbalancer_setup.enable == true ? var.loadbalancer_setup.members : {}
  
  address       = each.value.address
  protocol_port = each.value.port
  pool_id       = opentelekomcloud_lb_pool_v2.ecs_loadbalancer_pool[0].id
  subnet_id     = each.value.subnet_id

  depends_on = [ opentelekomcloud_lb_pool_v2.ecs_loadbalancer_pool[0] ]
}

resource "opentelekomcloud_dns_recordset_v2" "ecs_dns_private" {
  count       = var.enable_internal_dns == true ? 1 : 0
  zone_id     = var.private_dns_zone_id
  name        = var.internal_dns_record_name
  description = "${var.instance_name} private DNS record"
  ttl         = 300
  type        = "A"
  records     = var.loadbalancer_setup.enable == true ? [opentelekomcloud_lb_loadbalancer_v2.ecs_loadbalancer[0].vip_address] : [opentelekomcloud_compute_instance_v2.this.access_ip_v4]

  depends_on = [ opentelekomcloud_lb_listener_v2.ecs_loadbalancer_listener[0] ]
}
