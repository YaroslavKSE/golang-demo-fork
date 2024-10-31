variable "vpc_id" {
  description = "The VPC ID where the ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs where the ALB will be created"
  type        = list(string)
}
