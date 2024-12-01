# AWS provider
provider "aws" {
  region = "us-east-1"
}

# AMI Image details
data "aws_ami" "ami_latest" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

#Retriving info from remote state according to each deployment environment from network 
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "${var.env}-finalproject-acs730-group10" // bucket to get state according to different environments
    key    = "${var.env}-Network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}


#Tags
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix_all      = "${module.globalvars.prefix}-${var.env}"
}

module "globalvars" {
  source = "../globalvars"
}

# SSH key for deployment provided based on environment
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key-${var.env}"
  public_key = file(var.path_to_ssh_key)
  tags = merge({
    Name = "${local.prefix_all}"
    },
    local.default_tags
  )
}

# Bastion Server
resource "aws_instance" "Bastion_Server" {
  ami                         = data.aws_ami.ami_latest.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  subnet_id                   = data.terraform_remote_state.network.outputs.public_subnet_ids[0]
  security_groups             = [aws_security_group.sg_bastion_server.id]
  associate_public_ip_address = true
  
  lifecycle {
    create_before_destroy = true
  }
  
  tags = merge(local.default_tags,
    {
      "Name" = "${local.prefix_all}-Bastion-${var.env}"
    }
  )
}

