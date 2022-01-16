variable "namespace" {
  type    = string
}

variable "vpc" {
  type    = any
}

variable key_name {
  type    = string
}

variable "sg_pub_id" {
  type    = any
}

variable "sg_priv_id" {
  type    = any
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "iam_instance_profile" {
  default = "SSM"
}

variable "instance_count" {
  default = "1"
}