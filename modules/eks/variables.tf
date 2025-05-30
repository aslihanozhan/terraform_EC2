variable "env" {
  description = "Environment name"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM Role ARN for EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where worker nodes are launched"
  type        = string
}

variable "control_plane_sg_id" {
  description = "Security group ID of the EKS control plane"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of SSH key pair to allow SSH access to worker nodes"
  type        = string
  default     = ""
}

