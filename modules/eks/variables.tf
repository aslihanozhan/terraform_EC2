variable "env" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_groups" {
  description = "Map of EKS node groups to create"
  type = map(object({
    desired_size    = number
    min_size        = number
    max_size        = number
    instance_types  = list(string)
    capacity_type   = string
  }))
  default = {}
}

variable "node_security_group_additional_rules" {
  description = "Additional security group rules for EKS node groups"
  type = map(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    type        = string
    self        = optional(bool)
    cidr_blocks = optional(list(string))
  }))
  default = {}
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encryption (optional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

