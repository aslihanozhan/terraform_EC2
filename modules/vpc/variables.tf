variable "env" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Map of CIDR blocks for private subnets"
  type        = map(list(string))
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

