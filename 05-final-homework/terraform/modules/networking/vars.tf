variable "namespace" {
  default     = "barad1tos"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public Subnet Ciders"
  default     = [
    "10.0.10.0/24",
    "10.0.11.0/24"
  ]
}

variable "private_subnets" {
  description = "Private Subnet Ciders"
  default     = [
    "10.0.20.0/24",
    "10.0.21.0/24"
  ]
}

variable "database_subnets" {
  description = "Database Subnet Ciders"
  default     = [
    "10.0.30.0/24",
    "10.0.31.0/24"
  ]
}

variable "default_route_cidr_blocks" {
  description = "Security Group Ciders"
  default     = "0.0.0.0/0"
}