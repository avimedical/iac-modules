output "labels" {
  environment   = var.environment
  domain        = var.domain
  resource_type = var.resource_type
  resource_name = var.resource_name
}

output "short_name" {
  value = "${var.environment}-${var.domain}-${var.resource_name}"
}

output "full_name" {
  value = "${local.prefix}-${var.environment}-${var.domain}-${var.resource_type}-${var.resource_name}-${var.resource_iteration}"
}