output "alb_dns_name" {
  value       = aws_alb.external_alb.dns_name
}

output "sg_puplic_id" {
  value       = module.networking.sg_public_id
}

output "sg_private_id" {
  value       = module.networking.sg_private_id
}

output "sg_database_id" {
  value       = module.networking.sg_database_id
}

output "vpc_id" {
  value       = module.networking.vpc_id
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

output "nat_gateway_ip" {
  value       = module.networking.nat_gateway_ip
}

output "webserver_1_private_ip" {
  value       = module.ec2_web1.private_ip
}

output "webserver_2_private_ip" {
  value       = module.ec2_web2.private_ip
}

output "phpmyadmin_private_ip" {
  value       = module.ec2_phpmyadmin.private_ip
}

output "bastion_ip" {
  value       = module.ec2_bastion.public_ip
}

output "user_data_rendered_bastion" {
    value     = data.template_file.bastion_userdata.rendered
}