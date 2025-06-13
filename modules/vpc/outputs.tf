output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Map of private subnet IDs by type"
  value = {
    eks = aws_subnet.private_eks[*].id
    rds = aws_subnet.private_rds[*].id
  }
}

output "private_subnet_cidrs" {
  description = "Map of private subnet CIDRs"
  value = {
    eks = aws_subnet.private_eks[*].cidr_block
    rds = aws_subnet.private_rds[*].cidr_block
  }
}

