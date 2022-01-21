variable "namespace" {
  type = string
}

variable "default_route_cidr_blocks" {
  type    = string
  default = "0.0.0.0/0"
}