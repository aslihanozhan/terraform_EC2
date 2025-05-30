# MODULARIZING YOUR TERRAFORM CONFIGURATION 

# variables.tf

# AMI ID (default is Ubuntu 20.04 LTS in eu-north-1)
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-00241a57ffa2422f5"
}

# EC2 instance type
variable "instance_type" {
  description = "Instance type to launch"
  type        = string
  default     = "t3.micro"
}# MODULARIZING YOUR TERRAFORM CONFIGURATION 

# variables.tf

# AMI ID (default is Ubuntu 20.04 LTS in eu-north-1)
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-00241a57ffa2422f5"
}

# EC2 instance type
variable "instance_type" {
  description = "Instance type to launch"
  type        = string
  default     = "t3.micro"
}
