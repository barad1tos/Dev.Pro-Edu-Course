data "aws_availability_zones" "available" {}

resource "aws_vpc" "barad1tos_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.namespace}-vpc"
  }
}

resource "aws_internet_gateway" "barad1tos_gw" {
  vpc_id = aws_vpc.barad1tos_vpc.id

  tags = {
    Name = "${var.namespace}-igw"
  }
}

resource "aws_eip" "barad1tos_nat_gw_eip" {
  vpc = true

  tags = {
    Name = "${var.namespace}-nat_gw_eip"
  }
}

resource "aws_nat_gateway" "barad1tos_nat_gw" {
  allocation_id = aws_eip.barad1tos_nat_gw_eip.id
  subnet_id     = aws_subnet.barad1tos_public_subnets[0].id

  tags = {
    Name = "${var.namespace}-nat_gw"
  }

  depends_on = [aws_internet_gateway.barad1tos_gw, aws_eip.barad1tos_nat_gw_eip]
}

resource "aws_subnet" "barad1tos_public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.barad1tos_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.namespace}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "barad1tos_private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.barad1tos_vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.namespace}-private-${count.index + 1}"
  }
}

resource "aws_subnet" "barad1tos_database_subnets" {
  count             = length(var.database_subnets)
  vpc_id            = aws_vpc.barad1tos_vpc.id
  cidr_block        = element(var.database_subnets, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.namespace}-database-${count.index + 1}"
  }
}

resource "aws_route_table" "barad1tos_public_subnets_rt" {
  vpc_id = aws_vpc.barad1tos_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.barad1tos_gw.id
  }

  tags = {
    Name = "${var.namespace}-rt-public-subnets"
  }
}

resource "aws_route_table" "barad1tos_private_subnets_rt" {
  vpc_id = aws_vpc.barad1tos_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.barad1tos_nat_gw.id
  }

  tags = {
    Name = "${var.namespace}-rt-private-subnets"
  }
}

resource "aws_route_table" "barad1tos_database_subnets_rt" {
  vpc_id = aws_vpc.barad1tos_vpc.id

  tags = {
    Name = "${var.namespace}-rt-database-subnets"
  }
}

resource "aws_route_table_association" "barad1tos_public_routes" {
  count          = length(aws_subnet.barad1tos_public_subnets[*].id)
  route_table_id = aws_route_table.barad1tos_public_subnets_rt.id
  subnet_id      = element(aws_subnet.barad1tos_public_subnets[*].id, count.index)

}

resource "aws_route_table_association" "barad1tos_private_routes" {
  count          = length(aws_subnet.barad1tos_private_subnets[*].id)
  route_table_id = aws_route_table.barad1tos_private_subnets_rt.id
  subnet_id      = element(aws_subnet.barad1tos_private_subnets[*].id, count.index)

}

resource "aws_route_table_association" "barad1tos_database_routes" {
  count          = length(aws_subnet.barad1tos_database_subnets[*].id)
  route_table_id = aws_route_table.barad1tos_database_subnets_rt.id
  subnet_id      = element(aws_subnet.barad1tos_database_subnets[*].id, count.index)

}