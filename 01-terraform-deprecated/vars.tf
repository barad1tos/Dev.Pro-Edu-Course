variable "namespace" {
  default = "barad1tos"
  type    = string
}

variable "aws_vpc_id" {
  default = "vpc"
  type    = string
}

#AWS Region
variable "aws_region" {
  type    = string
  default = "us-east-2"
}