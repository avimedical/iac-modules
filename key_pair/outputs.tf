
output "pub_key" {
  value = opentelekomcloud_compute_keypair_v2.key_pair.public_key
}

output "key_pair_name" {
  value = opentelekomcloud_compute_keypair_v2.key_pair.name
}

output "priv_key" {
  value = opentelekomcloud_compute_keypair_v2.key_pair.private_key
}