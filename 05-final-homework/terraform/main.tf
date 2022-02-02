module "networking" {
  source = ".//modules/networking"
}

module "ec2_web" {
  source = ".//modules/ec2"
  count                = 2
  name                 = "${var.namespace}_web_${count.index + 1}"
  iam_instance_profile = aws_iam_instance_profile.barad1tos_instance_profile.name
  key_name             = aws_key_pair.ansible_key.key_name
  vpc_sg_ids           = [module.networking.sg_private_id]
  subnet_id_instance   = element(module.networking.private_subnet_ids[*], count.index)
  type                 = "webserver"
}

module "ec2_phpmyadmin" {
  count                = 2
  source               = ".//modules/ec2"
  name                 = "${var.namespace}_phpmyadmin_${count.index + 1}"
  iam_instance_profile = aws_iam_instance_profile.barad1tos_instance_profile.name
  key_name             = aws_key_pair.ansible_key.key_name
  vpc_sg_ids           = [module.networking.sg_private_id]
  subnet_id_instance   = element(module.networking.private_subnet_ids[*], count.index)
  type                 = "phpmyadmin"
}

module "ec2_database" {
  source = ".//modules/ec2"
  name = "${var.namespace}_database"
  iam_instance_profile = aws_iam_instance_profile.barad1tos_instance_profile.name
  key_name             = aws_key_pair.ansible_key.key_name
  vpc_sg_ids           = [module.networking.sg_database_id]
  subnet_id_instance   = module.networking.database_subnet_ids[0]
  type                 = "database"

  depends_on           = [
    module.ec2_web.instance,
    module.ec2_phpmyadmin.instance
  ]
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

  depends_on           = [
    module.ec2_database.instance
  ]
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

resource "aws_iam_role" "bastion_role" {
  name                 = "${var.namespace}_full_deployment"
  assume_role_policy   = data.aws_iam_policy_document.ec2_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name                 = "${var.namespace}_bastion_instance_profile"
  role                 = aws_iam_role.bastion_role.name
}

resource "aws_s3_bucket" "db_backup" {
  bucket               = "barad1tos-database-backup"

  lifecycle {
    prevent_destroy    = false
  }
  force_destroy        = true

  tags = {
    name               = "db_backup"
    environment        = var.namespace
  }
}