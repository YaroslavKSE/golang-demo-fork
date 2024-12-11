output "golang_app-instance_ids" {
  value = aws_instance.golang_app[*].id
}