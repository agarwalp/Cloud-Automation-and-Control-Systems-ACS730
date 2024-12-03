provider "aws" {
  region = var.region
}

#Referring to Network module via remote statefile
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "acs730finalproj-dev"
    key    = "environment/dev/network_module/terraform.tfstate" 
    region = "us-east-1"                                       
  }
}




# Auto Scaling Launch Configuration
resource "aws_launch_configuration" "WebServerLC" {
  name                        = "WebServerLaunchConfig-${formatdate("YYYYMMDD-HHmmss", timestamp())}"
  image_id                    = var.amiId
  instance_type               = var.instanceType
  security_groups             = [aws_security_group.WebServerSG.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  user_data                   = file("${path.module}/install_httpd_autoscaling.sh.tpl")

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "WebServerASG" {
  desired_capacity = var.desiredCapacity
  max_size         = var.maxSize
  min_size         = var.minSize

     # Use only public subnets 1 and 2
  vpc_zone_identifier = [
    data.terraform_remote_state.network.outputs.publicSubnetIds[0], # publicSubnet1
    data.terraform_remote_state.network.outputs.publicSubnetIds[1]  # publicSubnet2
  ]

  launch_configuration = aws_launch_configuration.WebServerLC.id

  target_group_arns = [aws_lb_target_group.WebTG.arn]

  tag {
    key                 = "Name"
    value               = "webServer-Autoscaled"
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

#Load Balancer Targe Group
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
  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
  tags = {
    Name = "webTG"
  }
}

#Load Balancer Listener
resource "aws_lb_listener" "WebListener" {
  load_balancer_arn = aws_lb.WebAlb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WebTG.arn
  }
}

#Load Balancer attachment group for Standalone webservers
resource "aws_lb_target_group_attachment" "StandaloneWebServers" {
  for_each = aws_instance.WebServer

  target_group_arn = aws_lb_target_group.WebTG.arn
  target_id        = each.value.id
  port             = 80
}


#Webserver in Public Subnet 2 and 3
resource "aws_instance" "WebServer" {
  for_each = {
    AZ3 = "webServer3"
    AZ4 = "webServer4"
  }

  ami                         = var.amiId
  instance_type               = var.instanceType
  subnet_id                   = each.key == "AZ3" ? data.terraform_remote_state.network.outputs.publicSubnetIds[2] : data.terraform_remote_state.network.outputs.publicSubnetIds[3]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  security_groups             = [aws_security_group.WebServerSG.id]

  tags = {
    Name = each.value
  }
}


# Webserver in Private Subnet 1
resource "aws_instance" "WebServer_Private1" {
  ami                         = var.amiId
  instance_type               = var.instanceType
  subnet_id                   = data.terraform_remote_state.network.outputs.privateSubnetIds[0] # PrivateSubnet1
  associate_public_ip_address = false
  key_name                    = var.key_pair_name
  security_groups             = [aws_security_group.WebServerSG.id]
  user_data                   = file("${path.module}/install_httpd.sh.tpl")

  tags = {
    Name = "webServer5"
  }
}

# Linux VM in Private Subnet 2
resource "aws_instance" "LinuxVM_Private2" {
  ami                         = var.amiId
  instance_type               = var.instanceType
  subnet_id                   = data.terraform_remote_state.network.outputs.privateSubnetIds[1] # PrivateSubnet2
  key_name                    = var.key_pair_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.privateVmSG.id]

  tags = {
    Name = "VM6"
  }
}


# Security Groups

#Security group for webservers
resource "aws_security_group" "WebServerSG" {
  vpc_id = data.terraform_remote_state.network.outputs.vpcId

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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

# Security Group for Private VM6
resource "aws_security_group" "privateVmSG" {
  vpc_id = data.terraform_remote_state.network.outputs.vpcId

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Example CIDR for private communication
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "privateVmSG"
  }
}

