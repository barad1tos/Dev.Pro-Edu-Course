
# Creating External LoadBalancer
resource "aws_alb" "external-alb" {
  name               = "${var.namespace}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.networking.allow_alb]
  subnets            = [module.networking.public_subnets[0],module.networking.public_subnets[1]]
}

 resource "aws_alb_target_group" "web_tg_1" {
   name               = "${var.namespace}-alb-web-1"
   port               = 80
   protocol           = "HTTP"
   vpc_id             = module.networking.vpc_id
   health_check {
     path             = "/"
   }
 }

 resource "aws_alb_target_group" "web_tg_2" {
   name               = "${var.namespace}-alb-web-2"
   port               = 80
   protocol           = "HTTP"
   vpc_id             = module.networking.vpc_id
   health_check {
     path             = "/phpmyadmin"
   }
 }

resource "aws_alb_target_group_attachment" "pub_srv" {
  count               = length(module.networking.public_subnets)
  target_group_arn    = aws_alb_target_group.web_tg_1.arn
  target_id           = element(module.ec2.aws_public_instance_id[*],count.index)
}

resource "aws_alb_target_group_attachment" "priv_srv" {
  count               = length(module.networking.private_subnets)
  target_group_arn    = aws_alb_target_group.web_tg_2.arn
  target_id           = element(module.ec2.aws_private_instance_id[*],count.index)
}

resource "aws_lb_listener" "first_listener" {
  load_balancer_arn   = aws_alb.external-alb.arn
  port                = "80"
  protocol            = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_alb_target_group.web_tg_1.arn
  }
}

resource "aws_lb_listener" "second_listener" {
  load_balancer_arn   = aws_alb.external-alb.arn
  port                = "8080"
  protocol            = "HTTP"

  default_action {
    type              = "forward"
    target_group_arn  = aws_alb_target_group.web_tg_2.arn
  }
}
