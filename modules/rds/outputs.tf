output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "db_name" {
  description = "Database name"
  value       = var.db_name
}

