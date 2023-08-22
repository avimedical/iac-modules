resource "opentelekomcloud_compute_instance_v2" "this" {
  name                = var.instance_name
  image_id            = var.image_id
  flavor_id           = var.flavor
  availability_zone   = var.availability_zone
  key_pair            = var.key_pair
  admin_pass          = var.admin_pass
  user_data           = var.user_data
  security_groups     = var.additional_security_group
  stop_before_destroy = true
  network {
    uuid = var.subnet_id
  }

  block_device {
    uuid                  = var.image_id
    volume_size           = var.ecs_volume_size
    volume_type           = var.ecs_volume_type
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = var.delete_on_termination
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

