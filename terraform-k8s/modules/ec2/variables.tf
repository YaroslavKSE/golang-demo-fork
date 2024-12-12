variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "golang_app_instance_type" {
  description = "Golang EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "golang_app_instance_count" {
  description = "Number of frontend instances to create"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-02db68a01488594c5" # Amazon Linux 2023 AMI
}

variable "user_data_vars" {
  description = "Variables for user data script"
  type = object({
    db_endpoint = string
    db_port     = string
    db_username = string
    db_password = string
    db_name     = string
    domain_name = string
  })
}