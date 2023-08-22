resource "opentelekomcloud_compute_keypair_v2" "key_pair" {
  name = "${var.instance_name}-key-pair"
}

output "pub_key" {
  value = opentelekomcloud_compute_keypair_v2.key_pair.public_key
}

output "key_pair_name" {
  value = opentelekomcloud_compute_keypair_v2.key_pair.name
}