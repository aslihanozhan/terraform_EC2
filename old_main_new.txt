
# Configure the AWS provider
provider "aws" {
  region = "eu-north-1" 
}

# Security Group
resource "aws_security_group" "exa" {
  name        = "security-group-asli"
  description = "Allow inbound SSH and HTTP"

  # Allow inbound SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22						 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Create EC2 Instance Resource
resource "aws_instance" "exa" {	
  # Amazon Machine Image - Ubuntu 20.04 LTS (for eu-north-1) 
  ami           = "ami-00da1738201099b91"

  # Instance type - t3.micro is free-tier eligible
  instance_type = "t3.micro"

  # Attach security group using VPC-compatible method
  security_groups = [aws_security_group.exa.name] 

  ##The Name tag is commonly used and will appear in the AWS Console
  tags = {
    Name = "AsliInstance"
  }
}

# Output the instance's public IP after creation.
output "instance_public_ip" {
  value = aws_instance.exa.public_ip
}


	
 

