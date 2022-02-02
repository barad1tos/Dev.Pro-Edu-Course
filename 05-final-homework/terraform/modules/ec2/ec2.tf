data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name      = "name"
    values    = ["amzn2-ami-hvm*"]
  }
}

# EC2 template
resource "aws_instance" "ec2_instance" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon-linux-2.id
  iam_instance_profile   = var.iam_instance_profile
  instance_type          = var.ec2_instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id_instance
  vpc_security_group_ids = var.vpc_sg_ids
  user_data              = var.user_data

 tags = {
    "Name" = "${var.namespace}_ec2_instance"
  }
}