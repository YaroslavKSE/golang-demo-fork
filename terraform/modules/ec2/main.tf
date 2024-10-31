resource "aws_security_group" "ec2" {
  name        = "ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-security-group"
  }
}

resource "aws_launch_template" "main" {
  name_prefix   = "golang-demo-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups            = [aws_security_group.ec2.id]
  }

  iam_instance_profile {
    name = var.ec2_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", var.user_data_vars))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "golang-demo-instance"
    }
  }

  key_name = var.key_name
}

resource "aws_autoscaling_group" "main" {
  desired_capacity    = var.instance_count
  max_size           = var.instance_count
  min_size           = var.instance_count
  target_group_arns  = [var.target_group_arn]
  vpc_zone_identifier = [var.subnet_id]

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "golang-demo-instance"
    propagate_at_launch = true
  }
}
