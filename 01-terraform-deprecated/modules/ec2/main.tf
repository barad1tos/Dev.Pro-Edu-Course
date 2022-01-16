# Create aws_ami filter to pick up the ami available in your region
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name      = "name"
    values    = ["amzn2-ami-hvm*"]
  }
}

# Configure the EC2 instance in a public subnet
resource "aws_instance" "ec2_public" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  # iam_instance_profile        = var.iam_instance_profile
  instance_type               = var.ec2_instance_type
  key_name                    = var.key_name
  subnet_id                   = var.vpc.public_subnets[0]
  vpc_security_group_ids      = [var.sg_pub_id]
  user_data                   = ".//scripts/nginx_setup.sh"

  tags = {
    "Name" = "${var.namespace}-EC2-PUBLIC"
  }

  # Copies the ssh key file to home dir
  provisioner "file" {
    source        = "./${var.key_name}.pem"
    destination   = "/home/ec2-user/${var.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${var.key_name}.pem")
      host        = self.public_ip
    }
  }

  #chmod key 400 on EC2 instance
  provisioner "remote-exec" {
    inline = ["chmod 400 ~/${var.key_name}.pem"]

    connection {
      type         = "ssh"
      user         = "ec2-user"
      private_key  = file("${var.key_name}.pem")
      host         = self.public_ip
    }

  }

}

# Configure the EC2 instance in a private subnet
resource "aws_instance" "ec2_private" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = false
# iam_instance_profile        = var.iam_instance_profile
  instance_type               = var.ec2_instance_type
  key_name                    = var.key_name
  subnet_id                   = var.vpc.private_subnets[1]
  vpc_security_group_ids      = [var.sg_priv_id]
  user_data                   = ".//scripts/LEMP_setup.sh"

  tags = {
    "Name" = "${var.namespace}-EC2-PRIVATE"
  }

}