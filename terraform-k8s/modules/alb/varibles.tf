variable "vpc_id" {
  description = "The VPC ID where the ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of public subnets for the ALB"
  type        = list(string)
}

variable "certificate_arn" {
  description = "The ARN of pre-generated SSL/TLS certificate"
  type        = string
}

variable "instance_ids" {
  description = "List of EC2 instance IDs to attach to the target group"
  type        = list(string)
}