resource "aws_instance" "golang_app" {
  count                  = var.golang_app_instance_count
  ami                    = var.ami_id
  instance_type          = var.golang_app_instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.golang_app_sg.id]
  subnet_id              = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/user_data.sh", {
    db_endpoint = var.user_data_vars.db_endpoint
    db_port     = var.user_data_vars.db_port
    db_username = var.user_data_vars.db_username
    db_password = var.user_data_vars.db_password
    db_name     = var.user_data_vars.db_name
    domain_name = var.user_data_vars.domain_name
    db_host     = split(":", var.user_data_vars.db_endpoint)[0]
  })

  tags = {
    Name = "golang-app-${count.index + 1}"
  }
}