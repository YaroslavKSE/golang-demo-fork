variable "vpc_id" {
  description = "The VPC ID where the RDS instance will be created"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs where the RDS instance will be created"
  type        = list(string)
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

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect to the RDS instance"
  type        = list(string)
}