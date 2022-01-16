####### Variables

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

####### Provider

provider "aws" {
   access_key = ""
   secret_key = ""
   region     = "us-east-2"
}

provider "cloudflare" {
   email = ""
   api_key = ""
   version = "~> 3.0"
}

####### VPC

resource "aws_vpc" "test_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" = "test_vpc"
  }
}

resource "aws_eip" "nat_gateway_A" {
  vpc = true
}

resource "aws_eip" "nat_gateway_B" {
  vpc = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "igw_main"
  }
}

####### NAT

resource "aws_nat_gateway" "nat_gateway_A" {
  allocation_id = aws_eip.nat_gateway_A.id
  subnet_id     = aws_subnet.public_A.id

  tags = {
    Name = "nat_gateway_A"
  }
}

resource "aws_nat_gateway" "nat_gateway_B" {
  allocation_id = aws_eip.nat_gateway_B.id
  subnet_id     = aws_subnet.public_B.id

  tags = {
    Name = "nat_gateway_B"
  }
}

####### Subnets

resource "aws_subnet" "public_A" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public_subnet_A"
  }
}

resource "aws_subnet" "public_B" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public_subnet_B"
  }
}

resource "aws_subnet" "private_A" {
  vpc_id                 = aws_vpc.test_vpc.id
  cidr_block             = "10.0.20.0/24"
  availability_zone      = "us-east-2a"
  
  tags = {
    Name = "private_subnet_A"
  }
}

resource "aws_subnet" "private_B" {
  vpc_id                 = aws_vpc.test_vpc.id
  cidr_block             = "10.0.21.0/24"
  availability_zone      = "us-east-2a"
  
  tags = {
    Name = "private_subnet_B"
  }
}

####### Route Tables

resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_subnet"
  }
}

resource "aws_route_table" "route_private_1A" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_A.id
  }

  tags = {
    Name = "route_private_1A"
  }
}

resource "aws_route_table" "route_private_1B" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_B.id
  }

  tags = {
    Name = "route_private_1B"
  }
}

resource "aws_route_table_association" "public_A" {
  subnet_id      = aws_subnet.public_A.id
  route_table_id = aws_route_table.route_public.id
}

resource "aws_route_table_association" "public_B" {
  subnet_id      = aws_subnet.public_B.id
  route_table_id = aws_route_table.route_public.id
}

resource "aws_route_table_association" "private_A" {
  subnet_id      = aws_subnet.private_A.id
  route_table_id = aws_route_table.route_public.id
}

resource "aws_route_table_association" "private_B" {
  subnet_id      = aws_subnet.private_B.id
  route_table_id = aws_route_table.route_public.id
}

####### Security-Group

resource "aws_security_group" "web_1" {
  name        = "allow_ssh"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id


  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh,http"
  }
}

resource "aws_security_group" "web_2" {
  name        = "allow_ssh,mysql"
  description = "Allow ssh, mysql and http inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id


  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "MYSQL from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh,mysql,http"
  }
}

resource "aws_security_group" "ALB_1" {
  name        = "ALB_traffic"
  description = "Allow ALB traffic"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "ALB_traffic"
  }
}

####### EC2

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
    owners = ["099720109477"]
}

resource "aws_network_interface" "web_1" {
  subnet_id       = aws_subnet.public_A.id
  security_groups = [aws_security_group.web_1.id]
}

resource "aws_network_interface" "web_2" {
  subnet_id       = aws_subnet.public_B.id
  security_groups = [aws_security_group.web_1.id]
}

resource "aws_network_interface" "web_3" {
  subnet_id       = aws_subnet.private_A.id
  security_groups = [aws_security_group.web_2.id]
}


resource "aws_instance" "ubuntu_1" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro" 
    iam_instance_profile   = "EC2_SSM"
    user_data              = file("scripts/nginx_setup.sh")

    network_interface {
      network_interface_id = aws_network_interface.web_1.id
      device_index = 0
    }

    root_block_device {
      volume_size = 8
    }
    
}

resource "aws_instance" "ubuntu_2" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro" 
    iam_instance_profile   = "EC2_SSM"
    user_data              = file("scripts/nginx_setup.sh")

    network_interface {
      network_interface_id = aws_network_interface.web_2.id
      device_index = 0
    }

    root_block_device {
      volume_size = 8
    }
    
}

resource "aws_instance" "ubuntu_3" {
    ami                    = data.aws_ami.ubuntu.id
    instance_type          = "t2.micro" 
    iam_instance_profile   = "EC2_SSM"
    user_data              = file("scripts/nginx_setup.sh")

    network_interface {
      network_interface_id = aws_network_interface.web_3.id
      device_index = 0
    }

    root_block_device {
      volume_size = 8
    }
    
}

####### ALB

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB_1.id]
  subnets            = [aws_subnet.public_A.id, aws_subnet.public_B.id]

}


resource "aws_lb_tg" "target_1" {
  name     = "tg_1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id
  health_check {
    path   = "/"
  }
}

resource "aws_lb_tg" "target_2" {
  name     = "tg_2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id
  health_check {
    path   = "/phpmyadmin"
  }
}


resource "aws_lb_tg_attachment" "attach_srv_1" {
  target_group_arn = aws_lb_tg.target_1.arn
  target_id        = aws_instance.ubuntu_1.id
  port             = 80
}

resource "aws_lb_tg_attachment" "attach_srv_2" {
  target_group_arn = aws_lb_tg.target_1.arn
  target_id        = aws_instance.ubuntu_2.id
  port             = 80
}

resource "aws_lb_tg_attachment" "attach_srv_3" {
  target_group_arn = aws_lb_tg.target_2.arn
  target_id        = aws_instance.ubuntu_3.id
  port             = 80
}

resource "aws_lb_listener" "listener_1" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_tg.target_1.arn
  }
}

resource "aws_lb_listener" "listener_2" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_tg.target_2.arn
  }
}

####### Cloudwatch

resource "aws_cloudwatch_dashboard" "terraform" {
  dashboard_name = "Dashboard_from_Terraform"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 12,
      "properties": {
        "metrics": [
        [ 
          "AWS/ApplicationELB", 
          "RequestCount", 
          "AvailabilityZone", 
          "us-east-2a" 
        ]
      ],
      "region": "us-east-2",
      "title": "RequestCount-fromELB"
      }
    },
    {
      "type": "text",
      "x": 0,
      "y": 7,
      "width": 3,
      "height": 3,
      "properties": {
        "markdown": "Test"
      }
    }
  ]
}
EOF
}


resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name                = "terraform-test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  threshold                 = "10"
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "alb"
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "alb"
      }
    }
  }
}


####### Cloudflare

resource "cloudflare_record" "console-paas" {
  zone_id = "928e4fd93ab7cb40d3117c747eae32e8"
  name    = "CNAME from alb"
  value   = aws_lb.alb.dns_name
  type    = "CNAME"
  proxied = true
}