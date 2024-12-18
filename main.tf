provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "my-ec2-key"
  public_key = file("/root/Fundbox/Fundbox/ssh-key/id_rsa.pub")
}

resource "aws_instance" "flask_app" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key.key_name
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
