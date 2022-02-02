resource "aws_alb" "external_alb" {
  name               = "${var.namespace}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.networking.sg_public_id]
  subnets            = module.networking.public_subnet_ids[*]

  tags = {
    Name = "${var.namespace}-alb"
  }
}

resource "aws_alb_listener" "external_alb_listener" {
  load_balancer_arn  = aws_alb.external_alb.arn
  port               = var.alb_port
  protocol           = var.alb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.barad1tos_web_tg_1.arn
  }
}

resource "aws_lb_listener_rule" "barad1tos_listener_rule" {
  listener_arn = aws_alb_listener.external_alb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.barad1tos_web_tg_2.arn
  }

  condition {
    path_pattern {
      values = ["/phpmyadmin/*"]
    }
  }
}

resource "aws_alb_target_group" "barad1tos_web_tg_1" {
  name              = var.web_tg_1_name
  port              = var.web_tg_1_port
  protocol          = var.web_tg_1_protocol
  vpc_id            = module.networking.vpc_id

  tags = {
    Name            = "${var.namespace}_tg_1"
  }
}

resource "aws_alb_target_group" "barad1tos_web_tg_2" {
  name              = var.web_tg_2_name
  port              = var.web_tg_2_port
  protocol          = var.web_tg_2_protocol
  vpc_id            = module.networking.vpc_id

  tags = {
    Name            = "${var.namespace}_tg_2"
  }
}

resource "aws_alb_target_group_attachment" "barad1tos_web_tg_1_1" {
  target_group_arn = aws_alb_target_group.barad1tos_web_tg_1.arn
  target_id        = module.ec2_web1.instance[0]
}

resource "aws_alb_target_group_attachment" "barad1tos_web_tg_1_2" {
  target_group_arn = aws_alb_target_group.barad1tos_web_tg_1.arn
  target_id        = module.ec2_web2.instance[0]
}

resource "aws_alb_target_group_attachment" "barad1tos_web_tg_2" {
  target_group_arn = aws_alb_target_group.barad1tos_web_tg_2.arn
  target_id        = module.ec2_phpmyadmin.instance[0]
}

resource "aws_cloudwatch_dashboard" "external_alb_cloudwatch" {
  dashboard_name = "barad1tos_alb"

  dashboard_body = <<EOF
  {
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
          [ "AWS/ApplicationELB",
            "HTTPCode_Target_2XX_Count",
            "TargetGroup",
            "${aws_alb_target_group.barad1tos_web_tg_1.arn_suffix}",
            "${aws_alb_target_group.barad1tos_web_tg_2.arn_suffix}",
            "LoadBalancer" ]
        ],
                "region": "var.region"
            }
        }
    ]
}
EOF
}