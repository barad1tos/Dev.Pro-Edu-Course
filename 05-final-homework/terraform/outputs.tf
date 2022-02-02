output "alb_green_dns_name" {
  value       = aws_alb.external_alb_green.dns_name
}

output "alb_blue_dns_name" {
  value       = aws_alb.external_alb_blue.dns_name
}

output "vpc_id" {
  value       = module.networking.vpc_id
}

/*
output "sg_public_id" {
  value       = module.networking.sg_public_id
}

output "sg_private_id" {
  value       = module.networking.sg_private_id
}

output "sg_database_id" {
  value       = module.networking.sg_database_id
}

output "public_subnet_ids" {
  value       = module.networking.public_subnet_ids[*]
}

output "private_subnet_ids" {
  value       = module.networking.private_subnet_ids[*]
}

output "database_subnet_ids" {
  value       = module.networking.database_subnet_ids[*]
}
*/
output "nat_gateway_ip" {
  value       = module.networking.nat_gateway_ip
}

output "webserver_1_private_ip" {
  value       = module.ec2_web[*].private_ip
}

output "phpmyadmin_private_ip" {
  value       = module.ec2_phpmyadmin[*].private_ip
}

output "db_private_ip" {
  value = module.ec2_database.private_ip
}

output "bastion_ip" {
  value       = module.ec2_bastion.public_ip
}

output "database_bucket_id" {
  value = aws_s3_bucket.db_backup.id
}