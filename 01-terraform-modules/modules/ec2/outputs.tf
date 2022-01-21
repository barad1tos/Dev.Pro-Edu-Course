output "public_ip" {
  value = try(aws_instance.ec2_public[0].public_ip)
}

output "private_ip" {
  value = try(aws_instance.ec2_private[0].private_ip)
}

output "aws_public_instance_id" {
  value = aws_instance.ec2_public[*].id
}

output "aws_private_instance_id" {
  value = aws_instance.ec2_private[*].id
}