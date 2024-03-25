output "username" {
  value       = local.username
  description = "The username for the postgresql user."
}

output "password" {
  value       = random_password.postgresql_user_password.result
  description = "The generated password for the postgresql user."
}