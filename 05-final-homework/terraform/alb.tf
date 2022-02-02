resource "aws_alb" "external_alb_green" {
  name               = "${var.namespace}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.networking.sg_public_id]
  subnets            = module.networking.public_subnet_ids[*]

  tags = {
    Name = "${var.namespace}-alb-green"
  }
}

resource "aws_alb_listener" "external_alb_listener_green" {
  load_balancer_arn  = aws_alb.external_alb_green.arn
  port               = var.alb_port
  protocol           = var.alb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.barad1tos_web_tg_green_1.arn
  }
}

resource "aws_lb_listener_rule" "barad1tos_listener_rule" {
  listener_arn = aws_alb_listener.external_alb_listener_green.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.barad1tos_web_tg_green_2.arn
  }

  condition {
    path_pattern {
      values = ["/phpmyadmin/*"]
    }
  }
}

resource "aws_alb_target_group" "barad1tos_web_tg_green_1" {
  name              = "${var.web_tg_1_name}-green"
  port              = var.web_tg_1_port
  protocol          = var.web_tg_1_protocol
  vpc_id            = module.networking.vpc_id

  tags = {
    Name            = "${var.namespace}_tg_green_1"
  }
}

resource "aws_alb_target_group" "barad1tos_web_tg_green_2" {
  name              = "${var.web_tg_2_name}-green"
  port              = var.web_tg_2_port
  protocol          = var.web_tg_2_protocol
  vpc_id            = module.networking.vpc_id

  tags = {
    Name            = "${var.namespace}_tg_green_2"
  }
}

resource "aws_alb_target_group_attachment" "barad1tos_web_tg_green_1" {
  count            = length(module.ec2_web[0].instance)
  target_group_arn = aws_alb_target_group.barad1tos_web_tg_green_1.arn
  target_id        = element(module.ec2_web[0].instance, count.index)
}

resource "aws_alb_target_group_attachment" "barad1tos_web_tg_green_2" {
  count            = length(module.ec2_phpmyadmin[0].instance)
  target_group_arn = aws_alb_target_group.barad1tos_web_tg_green_2.arn
  target_id        = element(module.ec2_phpmyadmin[0].instance, count.index)
}

resource "aws_alb" "external_alb_blue" {
  name             = "${var.namespace}-blue"
  subnets          = module.networking.public_subnet_ids[*]
  security_groups  = [module.networking.sg_public_id]

  tags = {
    name = "${var.namespace}_alb_blue"
  }
}

resource "aws_alb_listener" "external_alb_listener_blue" {
  load_balancer_arn = aws_alb.external_alb_blue.arn
  port              = var.alb_port
  protocol          = var.alb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.barad1tos_web_tg_blue_1.arn
  }
}

resource "aws_lb_listener_rule" "barad1tos_listener_rule_blue" {
  listener_arn       = aws_alb_listener.external_alb_listener_blue.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.barad1tos_web_tg_blue_2.arn
  }
  condition {
    path_pattern {
      values = ["/phpmyadmin/"]
    }
  }
}

resource "aws_alb_target_group" "barad1tos_web_tg_blue_1" {
  name             = "${var.web_tg_1_name}-blue"
  port             = var.web_tg_1_port
  protocol         = var.web_tg_1_protocol
  vpc_id           = module.networking.vpc_id

  tags = {
    name           = "${var.namespace}_tg_blue_1"
  }

  health_check {
    path           = "/index.html"
  }
}

resource "aws_alb_target_group" "barad1tos_web_tg_blue_2" {
  name             = "${var.web_tg_2_name}-blue"
  port             = var.web_tg_2_port
  protocol         = var.web_tg_2_protocol
  vpc_id           = module.networking.vpc_id

  tags = {
    name           = "${var.namespace}_tg_blue_2"
  }

  health_check {
    path = "/phpmyadmin/"
  }
}

resource "aws_alb_target_group_attachment" "barad1tos_web_tg_blue_1" {
  count            = length(module.ec2_web[1].instance)
  target_group_arn = aws_alb_target_group.barad1tos_web_tg_blue_1.arn
  target_id        = element(module.ec2_web[1].instance, count.index)
}

resource "aws_alb_target_group_attachment" "barad1tos_web_tg_blue_2" {
  count            = length(module.ec2_phpmyadmin[1].instance)
  target_group_arn = aws_alb_target_group.barad1tos_web_tg_blue_2.arn
  target_id        = element(module.ec2_phpmyadmin[1].instance, count.index)
}