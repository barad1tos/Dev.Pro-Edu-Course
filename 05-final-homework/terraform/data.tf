data "aws_region" "current" {}

data "aws_iam_policy_document" "ec2_policy" {
  statement {
    actions       = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "template_file" "bastion_userdata" {
  template = file("./bastion_userdata.sh.tpl")
  vars = {
    ansible_private_key = tls_private_key.ansible.private_key_pem
  }
}
