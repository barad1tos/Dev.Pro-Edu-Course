output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.barad1tos_vpc.id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = aws_subnet.barad1tos_public_subnets[*].id
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = aws_subnet.barad1tos_private_subnets[*].id
}

output "database_subnet_ids" {
  description = "Database Subnet IDs"
  value       = aws_subnet.barad1tos_database_subnets[*].id
}

output "nat_gateway_ip" {
  description = "List of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.barad1tos_nat_gw_eip.public_ip
}

output "sg_public_id" {
  description = "Public Security Group ID"
  value       = aws_security_group.barad1tos_sg_public.id
}

output "sg_private_id" {
  description = "Private Security Group ID"
  value       = aws_security_group.barad1tos_sg_private.id
}

output "sg_database_id" {
  description = "Database Security Group ID"
  value       = aws_security_group.barad1tos_sg_database.id
}