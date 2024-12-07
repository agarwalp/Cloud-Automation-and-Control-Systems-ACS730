terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
region = "us-east-1"
}


#Referring to Network module via remote statefile
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "group1-acs730finalproject-${var.env}"
    key    = "${var.env}/network_module/terraform.tfstate"
    region = "us-east-1"
  }
}
# Auto Scaling Launch Configuration
resource "aws_launch_configuration" "WebServerLC" {
  name                        = "${var.env}WebServerLaunchConfig-${formatdate("YYYYMMDD-HHmmss", timestamp())}"
  image_id                    = var.amiId
  instance_type               = var.instanceType
  security_groups             = [aws_security_group.WebServerSG.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
   user_data = templatefile("${path.module}/install_httpd.sh.tpl", {
   server_name = "${var.env}WebServer-AutoScaled"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "WebServerASG" {
  desired_capacity = var.desiredCapacity
  max_size         = var.maxSize
  min_size         = var.minSize

  # using only public subnets 1and2 for autoscaling
  vpc_zone_identifier = [
    data.terraform_remote_state.network.outputs.publicSubnetIds[0], # publicSubnet1
    data.terraform_remote_state.network.outputs.publicSubnetIds[1]  # publicSubnet2
  ]

  launch_configuration = aws_launch_configuration.WebServerLC.id

  target_group_arns = [aws_lb_target_group.WebTG.arn]

  tag {
    key                 = "Name"
    value               = "${var.env}WebServer-Autoscaled"
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
    Name = "${var.env}WebALB"
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
    Name = "${var.env}WebTG"
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

#Load Balancer attachment group for webservers
resource "aws_lb_target_group_attachment" "StandaloneWebServers" {
  for_each = aws_instance.WebServer

  target_group_arn = aws_lb_target_group.WebTG.arn
  target_id        = each.value.id
  port             = 80

  depends_on = [aws_instance.WebServer]
}


#Webservers in Public Subnet2and3
resource "aws_instance" "WebServer" {
  for_each = {
    AZ3 = "${var.env}WebServer3"
    AZ4 = "${var.env}WebServer4"
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


# Webserver and VM in Private Subnets
resource "aws_instance" "PrivateInstances" {
  for_each = {
    webServer5 = {
      name      = "${var.env}WebServer5"
      subnet_id = data.terraform_remote_state.network.outputs.privateSubnetIds[0] # Private Subnet 1
      sg        = aws_security_group.WebServerSG.id
      user_data = <<-EOT
        #!/bin/bash
        # Update packages and install Apache HTTP Server
        sudo yum update -y
        sudo yum install -y httpd

        # Start and enable Apache
        sudo systemctl start httpd
        sudo systemctl enable httpd

        # Define server name dynamically

        # Create the HTML file
        sudo bash -c 'cat > /var/www/html/index.html <<EOF
        <!DOCTYPE html>
        <html>
        <head>
            <title>ACS730-FinalProject-Group1</title>
        </head>
        <body>
            <h1 style="text-align: center; color: blue;">Webserver5</h1>
            <h1 style="text-align: center; color: blue;">AC730-FinalProject-Group1</h1>
            <p style="text-align: center;">Created by Pooja, Poonam, Shailendra, and Arjoo</p>
        </body>
        </html>
        EOF'

        # Ensure proper permissions
        sudo chmod -R 755 /var/www/html

        # Restart Apache to apply changes
        sudo systemctl restart httpd
      EOT
    }
    VM6 = {
      name      = "${var.env}VM6"
      subnet_id = data.terraform_remote_state.network.outputs.privateSubnetIds[1] # Private Subnet 2
      sg        = aws_security_group.privateVmSG.id
      user_data = null
    }
  }

  ami                         = var.amiId
  instance_type               = var.instanceType
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = false
  key_name                    = var.key_pair_name
  security_groups             = [each.value.sg]
  user_data                   = each.value.user_data

  tags = {
    Name = each.value.name
  }
}


# Security Groups
# Security group for webservers
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
    Name = "${var.env}WebServerSG"
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
    Name = "${var.env}PrivateVmSG"
  }
}

