output "username" {
  value       = local.username
  description = "The username for the MySQL user."
}

output "password" {
  value       = random_password.mysql_user_password.result
  description = "The generated password for the MySQL user."
}