resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Main DB subnet group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

data "aws_db_parameter_group" "postgres_disable_ssl" {
  name = "postgres-disable-ssl"
}

resource "aws_db_instance" "main" {
  identifier             = "main-db-instance"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16"
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = data.aws_db_parameter_group.postgres_disable_ssl.name
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "main-db-instance"
  }
}
