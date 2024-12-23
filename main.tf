provider "aws" {
  region = "us-east-1"
}

data "aws_key_pair" "existing" {
  key_name = "my-ec2-key"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "my-ec2-key"
  count      = length(data.aws_key_pair.existing.id == "" ? [1] : [])
  public_key = var.ssh_public_key
}

variable "ssh_public_key" {}

resource "aws_instance" "flask_app" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      =  length(aws_key_pair.ec2_key) > 0 ? aws_key_pair.ec2_key[0].key_name : data.aws_key_pair.existing.key_name
  security_groups = [aws_security_group.flask_sg.name]

  tags = {
    Name = "FlaskAppInstance"
  }
}

resource "aws_security_group" "flask_sg" {
  name_prefix = "flask-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all IPs; restrict in production environments
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.flask_app.public_ip
}
