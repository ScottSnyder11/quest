resource "aws_security_group" "alb_sg" {
  name        = "alb_sg_for_quest"
  description = "Security group for the Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

resource "aws_lb" "quest" {
  name               = "quest-alb"
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]
  
  enable_deletion_protection = false
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.quest.arn
  port              = 443
  protocol          = "HTTPS"
  
  ssl_policy     = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest.arn
  }
}

# Create Target Group with Health Check
resource "aws_lb_target_group" "quest" {
  name     = "quest-tg-http"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 60
    timeout             = 30
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
}

resource "aws_lb_target_group_attachment" "quest" {
  target_group_arn = aws_lb_target_group.quest.arn
  target_id        = var.instance_id[0]
  port             = 80
}
