output "username" {
  value = local.username
}

output "password" {
  value = random_password.mysql_user_password.result
}