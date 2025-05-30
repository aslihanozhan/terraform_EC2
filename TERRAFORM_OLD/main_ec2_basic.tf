# Provider configuration (AWS)
provider "aws" {
  region = "eu-north-1" # Stockholm region
}

# Security Group
resource "aws_security_group" "example" {
  name        = "security-group"
  description = "Allow inbound SSH and HTTP"

  # Allow inbound SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Any IP address can access this port
  }

  # Allow inbound HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 Instance resource
resource "aws_instance" "example" {
  ami             = "ami-00da1738201099b91" # Amazon Machine Image
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.example.name]

  tags = {
    Name = "EC2InstanceAsli"
  }
}
