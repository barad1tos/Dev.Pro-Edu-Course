output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.amazon-linux-2.id
}

output "latest_amazon_linux_ami_name" {
  value = data.aws_ami.amazon-linux-2.id
}

output "instance" {
  value = aws_instance.ec2_instance[*].id
}

output "public_ip" {
  value = try(aws_instance.ec2_instance[0].public_ip)
}

output "private_ip" {
  value = try(aws_instance.ec2_instance[0].private_ip)
}