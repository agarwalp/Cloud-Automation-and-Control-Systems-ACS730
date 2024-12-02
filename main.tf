provider "aws" {
  region = var.region
}

# Security Groups
resource "aws_security_group" "WebServerSG" {
  name_prefix = "${var.environment}-WebServer-SG"
  vpc_id      = var.vpcId

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowedHttpIps
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowedSshIps
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-WebServer-SG"
    Environment = var.environment
  }
}

# Auto Scaling Group and Launch Configuration
resource "aws_launch_configuration" "WebServerLC" {
  name          = "${var.environment}-WebServer-LC"
  image_id      = var.amiId
  instance_type = var.instanceType
  security_groups = [
    aws_security_group.WebServerSG.id
  ]
  user_data = file("${path.module}/install_httpd.sh.tpl")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "WebServerASG" {
  desired_capacity     = var.desiredCapacity
  max_size             = var.maxSize
  min_size             = var.minSize
  vpc_zone_identifier  = var.publicSubnets
  launch_configuration = aws_launch_configuration.WebServerLC.id
  
  target_group_arns = [aws_lb_target_group.WebTG.arn] 

  tag {
    key                 = "Name"
    value               = "${var.environment}-WebServer"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Load Balancer
resource "aws_lb" "WebAlb" {
  name               = "${var.environment}-Web-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.WebServerSG.id]
  subnets            = var.publicSubnets

  tags = {
    Name        = "${var.environment}-Web-ALB"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "WebTG" {
  name     = "${var.environment}-Web-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpcId

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "WebListener" {
  load_balancer_arn = aws_lb.WebAlb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WebTG.arn
  }
}

