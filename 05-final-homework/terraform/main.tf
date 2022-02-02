module "networking" {
  source = ".//modules/networking"
}

module "ec2_web1" {
  source = ".//modules/ec2"
  name                 = "${var.namespace}_web_1"
  iam_instance_profile = aws_iam_instance_profile.barad1tos_instance_profile.name
  key_name             = aws_key_pair.ansible_key.key_name
  vpc_sg_ids           = [module.networking.sg_private_id]
  subnet_id_instance   = module.networking.private_subnet_ids[0]
  type                 = "webserver"
}

module "ec2_web2" {
  source               = ".//modules/ec2"
  name                 = "${var.namespace}_web_2"
  iam_instance_profile = aws_iam_instance_profile.barad1tos_instance_profile.name
  key_name             = aws_key_pair.ansible_key.key_name
  vpc_sg_ids           = [module.networking.sg_private_id]
  subnet_id_instance   = module.networking.private_subnet_ids[1]
  type                 = "webserver"
}

module "ec2_phpmyadmin" {
  source               = ".//modules/ec2"
  name                 = "${var.namespace}_phpmyadmin"
  iam_instance_profile = aws_iam_instance_profile.barad1tos_instance_profile.name
  key_name             = aws_key_pair.ansible_key.key_name
  vpc_sg_ids           = [module.networking.sg_private_id]
  subnet_id_instance   = module.networking.private_subnet_ids[0]
  type                 = "phpmyadmin"
}

module "ec2_bastion" {
  source               = ".//modules/ec2"
  name                 = "${var.namespace}_ec2_bastion"
  iam_instance_profile = aws_iam_instance_profile.barad1tos_instance_profile.name
  key_name             = aws_key_pair.bastion_key.key_name
  vpc_sg_ids           = [module.networking.sg_public_id]
  subnet_id_instance   = module.networking.public_subnet_ids[0]
  user_data            = data.template_file.bastion_userdata.rendered
  env                  = "bastion"
}

resource "aws_iam_role" "barad1tos_iam_role" {
  name                 = "SSM-CloudWatch-Full-S3-ReadOnly"
  assume_role_policy   = data.aws_iam_policy_document.ec2_policy.json
  managed_policy_arns  = [
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

resource "aws_iam_instance_profile" "barad1tos_instance_profile" {
  name                 = "${var.namespace}-instance_profile"
  role                 = aws_iam_role.barad1tos_iam_role.name
}