
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name                             = "${var.namespace}-vpc"
  cidr                             = "10.0.0.0/16"
  azs                              = data.aws_availability_zones.available.names
  private_subnets                  = ["10.0.10.0/24", "10.0.11.0/24"]
  public_subnets                   = ["10.0.20.0/24", "10.0.21.0/24"]
  database_subnets                 = ["10.0.30.0/24", "10.0.31.0/24"]
  create_database_subnet_group     = true
  enable_nat_gateway               = true
  single_nat_gateway               = false
  one_nat_gateway_per_az           = false
}



# Inbound Rules for HTTP, HTTPS. SSH access from anywhere
resource "aws_security_group" "allow_pub" {
  name            = "${var.namespace}-allow_pub"
  description     = "Allow public inbound traffic"
  vpc_id          = module.vpc.vpc_id

  dynamic "ingress" {
    for_each  = ["80","443","22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port     = 0
    protocol      = "-1"
    to_port       = 0
    cidr_blocks   = [var.default_route_cidr_blocks]
  }

  tags = {
    Name = "${var.namespace}-allow_pub"
  }
}

# Define

resource "aws_security_group" "allow_priv" {
  name            = "${var.namespace}-allow_riv"
  description     = "Allow private inbound traffic"
  vpc_id          = module.vpc.vpc_id


  dynamic "ingress" {
    for_each = ["80","3306","22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.default_route_cidr_blocks]
    }
  }

  egress {
    from_port     = 0
    protocol      = "-1"
    to_port       = 0
    cidr_blocks   = [var.default_route_cidr_blocks]
  }

  tags = {
    Name = "${var.namespace}-allow_priv"
  }
}

resource "aws_security_group" "allow_alb" {
  name            = "ALB Security group"
  description     = "Allow all traffic to LB"
  vpc_id          = module.vpc.vpc_id

dynamic "ingress" {
  for_each        = ["80"]
  content {
    from_port     = ingress.value
    to_port       = ingress.value
    protocol      = "tcp"
    cidr_blocks   = [var.default_route_cidr_blocks]
  }
 }
  egress {
    from_port     = 0
    protocol      = "-1"
    to_port       = 0
    cidr_blocks   = [var.default_route_cidr_blocks]
  }

  tags = {
    Name = "${var.namespace}-allow_alb"
  }
}