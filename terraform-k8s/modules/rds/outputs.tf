output "db_instance_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_instance_name" {
  value = aws_db_instance.main.db_name
}