resource "aws_security_group" "barad1tos_sg_public" {
  name   = "Allow public inbound traffic"
  vpc_id = aws_vpc.barad1tos_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.default_route_cidr_blocks]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_route_cidr_blocks]
  }

  tags = {
    Name = "${var.namespace}-sg_public"
  }
}

resource "aws_security_group" "barad1tos_sg_private" {
  name   = "Allow private inbound traffic"
  vpc_id = aws_vpc.barad1tos_vpc.id

  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.barad1tos_sg_public.id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_route_cidr_blocks]
  }

  tags = {
    Name = "${var.namespace}-sg_private"
  }
}

resource "aws_security_group" "barad1tos_sg_database" {
  name   = "Allow db inbound traffic"
  vpc_id = aws_vpc.barad1tos_vpc.id

  dynamic "ingress" {
    for_each = ["3306", "22"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.barad1tos_sg_private.id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.default_route_cidr_blocks]
  }

  tags = {
    Name = "${var.namespace}-sg_database"
  }
}
