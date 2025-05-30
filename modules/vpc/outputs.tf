output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

