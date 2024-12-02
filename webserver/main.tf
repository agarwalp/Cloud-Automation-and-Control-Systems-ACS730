provider "aws" {
  region = var.region
}

data "terraform_remote_state" "network" {
  backend = "local" # Use local state if the network module was applied locally
  config = {
    path = "../network module/terraform.tfstate" # Path to the network module's state file
  }
}

# Security Groups
resource "aws_security_group" "WebServerSG" {
  vpc_id = data.terraform_remote_state.network.outputs.vpcId

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "webServerSG"
  }
}

# Auto Scaling Group and Launch Configuration
resource "aws_launch_configuration" "WebServerLC" {
  name          = "WebServerLaunchConfig"
  image_id      = var.amiId
  instance_type = var.instanceType
  security_groups = [
    aws_security_group.WebServerSG.id
  ]
  associate_public_ip_address = true
  user_data = file("${path.module}/install_httpd.sh.tpl")

  # Add name prefix to instances created by this configuration
  tags = [
    {
      key                 = "Name"
      value               = "WebServer"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "WebServerASG" {
  desired_capacity     = var.desiredCapacity
  max_size             = var.maxSize
  min_size             = var.minSize
  vpc_zone_identifier  = [for k, v in data.terraform_remote_state.network.outputs.publicSubnetIds :
    v if v.az in ["us-east-1a", "us-east-1b"]]
  launch_configuration = aws_launch_configuration.WebServerLC.id

  target_group_arns = [aws_lb_target_group.WebTG.arn]

  tag {
    key                 = "Name"
    value               = "WebServer" # Common prefix for the instances
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Load Balancer
resource "aws_lb" "WebAlb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.WebServerSG.id]
  subnets            = data.terraform_remote_state.network.outputs.publicSubnetIds

  tags = {
    Name = "webALB"
  }
}

resource "aws_lb_target_group" "WebTG" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.network.outputs.vpcId

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "webTG"
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


///////////

# Standalone Webserver in AZ3
resource "aws_instance" "WebServer_AZ3" {
  ami           = var.amiId
  instance_type = var.instanceType
  subnet_id     = data.terraform_remote_state.network.outputs.publicSubnetIds[2] # AZ3
  associate_public_ip_address = true

  tags = {
    Name = "WebServer3"
  }
}

# Standalone Webserver in AZ4
resource "aws_instance" "WebServer_AZ4" {
  ami           = var.amiId
  instance_type = var.instanceType
  subnet_id     = data.terraform_remote_state.network.outputs.publicSubnetIds[3] # AZ4
  associate_public_ip_address = true

  tags = {
    Name = "WebServer4"
  }
}

# Webserver in Private Subnet 1
resource "aws_instance" "WebServer_Private1" {
  ami           = var.amiId
  instance_type = var.instanceType
  subnet_id     = data.terraform_remote_state.network.outputs.privateSubnetIds[0] # PrivateSubnet1
  associate_public_ip_address = false

  tags = {
    Name = "WebServer5"
  }
}

# Linux VM in Private Subnet 2
resource "aws_instance" "LinuxVM_Private2" {
  ami           = var.amiId
  instance_type = var.instanceType
  subnet_id     = data.terraform_remote_state.network.outputs.privateSubnetIds[1] # PrivateSubnet2
  associate_public_ip_address = false

  tags = {
    Name = "VM6"
  }
}
