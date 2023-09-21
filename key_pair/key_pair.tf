resource "opentelekomcloud_compute_keypair_v2" "key_pair" {
  name = "${var.instance_name}-key-pair"
}
