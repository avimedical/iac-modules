output "private_key_pem" {
  value = tls_private_key.private_key.private_key_pem
}

output "cert" {
  value = cloudflare_origin_ca_certificate.ca_cert.certificate
}