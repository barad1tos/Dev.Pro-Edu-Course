resource "tls_private_key" "ansible" {
  algorithm  = "RSA"
  rsa_bits   = 4096
}

resource "aws_key_pair" "ansible_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ansible.public_key_openssh

  provisioner "local-exec" {
    command  = <<-EOT
    echo '${tls_private_key.ansible.private_key_pem}' > ./'${var.key_name}'.pem
    chmod 400 ./'${var.key_name}'.pem
  EOT
  }
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion"
  public_key = file("bastion.pub")

  tags = {
    Name = "$(var.namespace)-key"
  }
}