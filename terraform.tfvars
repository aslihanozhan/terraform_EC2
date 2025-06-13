# AWS Region
aws_region = "eu-north-1"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"
azs = ["eu-north-1a", "eu-north-1b"]

# Subnet Configuration
public_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
private_subnet_cidrs = {
  eks = ["10.0.1.0/24", "10.0.2.0/24"]
  rds = ["10.0.3.0/24", "10.0.4.0/24"]
}

# Environment
env = "dev"

# Tags
tags = {
  Environment = "dev"
  Owner       = "asli"
  Project     = "asli-eks"
  Terraform   = "true"
}

# RDS Configuration
db_username = "admin"
db_password = "SuperSecret123!"
instance_type = "db.t3.micro"
allocated_storage = 20

# EKS Configuration
cluster_name = "asli-eks-cluster"
cluster_version = "1.27"

# Security Group Configuration
control_plane_sg_id = "sg-06ab43f49e007ddfe"

# EKS Node Group Configuration
eks_node_instance_types = ["t3.medium"]
eks_node_desired_size   = 2
eks_node_min_size       = 1
eks_node_max_size       = 3
eks_node_disk_size      = 20

# RDS Configuration
rds_database_name   = "myappdb"
rds_username       = "postgres"
rds_password       = "your-secure-password-here"  # Replace with your secure password
rds_instance_type  = "db.t3.micro"
rds_allocated_storage = 20

# GitHub Configuration
github_repo = "aslihanozhan/ArgoCd"
