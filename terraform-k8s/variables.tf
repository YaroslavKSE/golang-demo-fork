variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-02db68a01488594c5" # Amazon Linux 2023 AMI
}

variable "certificate_arn" {
  description = "The arn of pregenerated SSL/TLS certificat"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "golang_app_instance_type" {
  description = "RocketDexK8s EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "golang_app_instance_count" {
  description = "Number of frontend instances to create"
  type        = number
  default     = 1
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "golang.academichub.net"
}


variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}