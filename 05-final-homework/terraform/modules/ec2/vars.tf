variable "instance_count" {
  default = "1"
}

variable "namespace" {
  default = "barad1tos"
}

variable "name" {
  type    = string
  default = ""
}

variable "type" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = "dev"
}

variable "subnet_id_instance" {
  default = ""
}

variable "key_name" {
  default = ""
}

variable "iam_instance_profile" {
  default = "SSM"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "public_subnet_id" {
  default = ""
}

variable "subnet_id_phpmyadmin" {
  default = ""
}

variable "vpc_sg_ids" {
  default = ""
}

variable "user_data" {
  default = ""
}