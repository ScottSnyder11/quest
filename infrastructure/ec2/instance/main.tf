# Security group for EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg_for_quest"
  description = "Security group for the EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}

data "aws_secretsmanager_secret" "my_secret" {
  name = "rearc/dev"
}

data "aws_secretsmanager_secret_version" "my_secret" {
  secret_id = data.aws_secretsmanager_secret.my_secret.id
}

locals {
  my_secrets = jsondecode(data.aws_secretsmanager_secret_version.my_secret.secret_string)
}

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[0]
  security_groups = [aws_security_group.instance_sg.id]
  iam_instance_profile = var.iam_instance_profile

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
echo "${local.my_secrets["DOCKER_PASSWORD"]}" | sudo docker login --username "${local.my_secrets["DOCKER_USER"]}" --password-stdin
sudo docker run -d -p 443:3000 -p 80:3000 -e "SECRET_WORD=${local.my_secrets["SECRET_WORD"]}" ${var.docker_image_name}
EOF

  tags = {
    Name = "Scott-Snyder-Rearc"
  }
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}
