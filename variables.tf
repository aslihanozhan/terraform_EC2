# Region-Availability Info
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "availability_zone" {
  default = "eu-north-1a"
}

# VPC_Subnet Info
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "MainVPC"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = map(list(string))
  default     = {
    eks = ["10.0.1.0/24", "10.0.2.0/24"]
    rds = ["10.0.3.0/24", "10.0.4.0/24"]
  }
}

variable "azs" {
  type    = list(string)
  default = ["eu-north-1a", "eu-north-1b"]
}

# Security_Group
variable "sg_name" {
  default = "RDSSecurityGroup"
}

#RDS Engine and Version
variable "db_engine" {
  default = "postgresql"
}

variable "db_engine_version" {
  default = "14.7"
}

#RDS Credentials
variable "db_username" {
  description = "Master DB username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master DB password"
  type        = string
  sensitive   = true
}

#DB_NAME
variable "db_name" {
  default = "myappdb"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for RDS in GB"
  type        = number
  default     = 20
}

#variable "lambda_function_name" {
#  default = "HelloLambda"
#}

variable "control_plane_sg_id" {
  description = "Security group ID of EKS control plane"
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key name for EKS worker nodes"
  type        = string
  default     = ""
}

# EKS Variables
variable "eks_cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "eks_node_instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "eks_node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "eks_node_disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "existing_security_group_id" {
  description = "ID of existing security group to use"
  type        = string
  default     = "sg-06ab43f49e007ddfe"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "asli-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Owner       = "asli"
    Project     = "asli-eks"
    Terraform   = "true"
  }
}

# RDS variables
variable "rds_database_name" {
  description = "Name of the RDS database"
  type        = string
  default     = "myappdb"
}

variable "rds_username" {
  description = "Username for the RDS database"
  type        = string
  default     = "postgres"
}

variable "rds_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}

variable "rds_instance_type" {
  description = "Instance type for the RDS database"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage for the RDS database in GB"
  type        = number
  default     = 20
}

# GitHub variables
variable "github_repo" {
  description = "GitHub repository in the format owner/repo"
  type        = string
  default     = "aslihanozhan/ArgoCd"
}

