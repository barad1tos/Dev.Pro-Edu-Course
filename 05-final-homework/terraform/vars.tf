variable "cloudflare_email" {
  default = "roman.borodavkin@dev.pro"
}

variable "api_key" {
  default = "febc43fbb1999c569bf58a35750089e790aa1"
}

variable "domain" {
  default = "barad1tos.xyz"
}

variable "zone" {
  default = "2924d0079cd642154d8a059e00c21499"
}

variable "key_name" {
  default = "ansible"
}

variable "namespace" {
  default = "barad1tos"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "web_tg_1_name" {
  default = "barad1tos-tg-webserver"
}

variable "web_tg_1_port" {
  default = "80"
}

variable "web_tg_1_protocol" {
  default = "HTTP"
}

variable "web_tg_2_name" {
  default = "barad1tos-tg-phpmyadmin"
}

variable "web_tg_2_port" {
  default = "80"
}

variable "web_tg_2_protocol" {
  default = "HTTP"
}

variable "alb_port" {
  default = "80"
}

variable "alb_protocol" {
  default = "HTTP"
}

variable "aws_alb_listener_port" {
  default = "80"
}

variable "aws_alb_listener_protocol" {
  default = "HTTP"
}

variable "enable_green_cloudflare" {
  type    = bool
  default = true
}

variable "enable_blue_cloudflare" {
  type    = bool
  default = true
}