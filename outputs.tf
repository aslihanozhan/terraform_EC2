output "rds_endpoint" {
  description = "The endpoint address of the RDS instance"
  value       = module.aws_rds.rds_endpoint
}

output "rds_database_name" {
  description = "The database name for the RDS instance"
  value       = module.aws_rds.db_name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

# Remove or comment out Lambda outputs unless you have a lambda module with these outputs
# output "lambda_function_name" {
#   description = "The name of the deployed Lambda function"
#   value       = module.lambda_module.lambda_function_name
# }
#
# output "lambda_function_arn" {
#   description = "The ARN (Amazon Resource Name) of the Lambda function"
#   value       = module.lambda_module.lambda_function_arn
# }

