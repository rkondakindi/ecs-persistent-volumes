resource "aws_alb" "my_lb" {
  name                       = "${var.stack_name}-${var.lb_name}-alb-${var.environment}"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.subnets
  security_groups            = [var.alb_sg]
  idle_timeout               = "15"
  enable_deletion_protection = false
  tags                       = merge({ Name = "${var.stack_name}-${var.lb_name}" }, local.default_tags)
}

resource "aws_alb_target_group" "my_target_group" {
  name        = "${var.stack_name}-${var.lb_name}-tg-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  depends_on  = [aws_alb.my_lb]
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
    protocol            = "HTTP"
    path                = "/"
  }
}

resource "aws_alb_listener" "my_load_balancer_listener" {
  load_balancer_arn = aws_alb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.my_target_group.arn
    type             = "forward"
  }
}