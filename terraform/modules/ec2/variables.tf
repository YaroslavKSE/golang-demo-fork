variable "vpc_id" {
  description = "The VPC ID where the EC2 instance will be created"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be created"
  type        = string
}

variable "instance_type" {
  description = "The instance type of the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The key pair name for the EC2 instance"
  type        = string
}

variable "ec2_profile_name" {
  description = "The IAM instance profile name for the EC2 instance"
  type        = string
}

variable "user_data_vars" {
  description = "Variables to pass to the user data script"
  type        = map(string)
}