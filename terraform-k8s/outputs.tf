output "golang_app_instance_id" {
  value = module.ec2.golang_app-instance_ids
}

output "website_endpoint" {
  description = "The HTTPS endpoint for the golang application"
  value       = "https://${aws_route53_record.golang-deployment-task.name}"
}