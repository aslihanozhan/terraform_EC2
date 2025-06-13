# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

# Configure Terraform Settings
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create VPC and networking components
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  azs                  = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  env                  = var.env
  tags                 = var.tags
  region               = var.aws_region
}

# Create EKS cluster
module "eks" {
  source = "./modules/eks"

  cluster_name    = "${var.env}-eks-cluster"
  cluster_version = var.eks_cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids["eks"]
  env             = var.env
  tags            = var.tags

  # Node group configuration
  node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 3
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
}

# Create RDS instance
module "aws_rds" {
  source = "./modules/rds"

  env                = var.env
  private_subnet_ids = module.vpc.private_subnet_ids["rds"]
  db_name            = var.rds_database_name
  db_username        = var.rds_username
  db_password        = var.rds_password
  db_sg_id           = aws_security_group.rds_sg.id
  instance_type      = var.rds_instance_type
  allocated_storage  = var.rds_allocated_storage
}

# Create RDS security group
resource "aws_security_group" "rds_sg" {
  name        = "${var.env}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]  # Use the CIDR blocks of your private subnets
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env}-rds-sg"
    }
  )
}

# Create IAM roles and policies for GitHub Actions
module "iam" {
  source = "./modules/iam"

  aws_account_id = data.aws_caller_identity.current.account_id
  github_repo    = var.github_repo
}

