output "vpc" {
  value       = module.vpc
}

output "vpc_id" {
  value       = module.vpc.vpc_id
}

output "sg_pub_id" {
  value       = aws_security_group.allow_pub.id
}

output "sg_priv_id" {
  value       = aws_security_group.allow_priv.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "allow_alb" {
  value       = aws_security_group.allow_alb.id
}