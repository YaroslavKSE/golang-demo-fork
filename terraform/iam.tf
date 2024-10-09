# iam.tf

# Data source for existing IAM Role
data "aws_iam_role" "ec2_role" {
  name = "ec2_instance_role"
}

# Data source for existing IAM Instance Profile
data "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_role"
}