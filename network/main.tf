provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  defaultTags = {
    Project     = "ACS730-Group1",
    ManagedBy   = "Terraform",
    Environment = var.environment
  }
}

resource "aws_vpc" "myVpc" {
  cidr_block           = var.vpcCidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    local.defaultTags,
    {
      Name = "acs730-group1-vpc"
    }
  )
}

resource "aws_subnet" "myPublicSubnets" {
  for_each         = toset(var.publicCidrs)
  vpc_id           = aws_vpc.myVpc.id
  cidr_block       = each.value
  availability_zone = element(data.aws_availability_zones.available.names, index(var.publicCidrs, each.value))
  tags = merge(
    local.defaultTags,
    {
      Name = "acs730-group1-public-subnet-${index(var.publicCidrs, each.value)}"
    }
  )
}

resource "aws_subnet" "myPrivateSubnets" {
  for_each          = toset(var.privateCidrs)
  vpc_id            = aws_vpc.myVpc.id
  cidr_block        = each.value
  availability_zone = element(data.aws_availability_zones.available.names, index(var.privateCidrs, each.value))
  map_public_ip_on_launch = false
  tags = merge(
    local.defaultTags,
    {
      Name = "acs730-group1-private-subnet-${index(var.privateCidrs, each.value)}"
    }
  )
}

resource "aws_nat_gateway" "myNatGateway" {
  allocation_id = aws_eip.myNatGatewayEip.id
  subnet_id     = aws_subnet.myPublicSubnets["${var.publicCidrs[1]}"].id
  tags = merge(
    local.defaultTags,
    {
      Name = "acs730-group1-nat-gateway"
    }
  )
}

resource "aws_eip" "myNatGatewayEip" {
  domain = "vpc" 
  tags = {
    Name = "acs730-group1-nat-gateway-eip"
  }
  depends_on = [aws_internet_gateway.myInternetGateway]
}

resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = aws_vpc.myVpc.id
  tags = merge(
    local.defaultTags,
    {
      Name = "acs730-group1-internet-gateway"
    }
  )
}

resource "aws_route_table" "myPrivateTable" {
  vpc_id = aws_vpc.myVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.myNatGateway.id
  }
  tags = merge(
    local.defaultTags,
    {
      Name = "acs730-group1-private-table"
    }
  )
}

resource "aws_route_table" "myPublicTable" {
  vpc_id = aws_vpc.myVpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInternetGateway.id
  }
  tags = {
    Name = "acs730-group1-public-table"
  }
}

resource "aws_route_table_association" "myPublicTableAssociation" {
  for_each      = aws_subnet.myPublicSubnets
  route_table_id = aws_route_table.myPublicTable.id
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "myPrivateTableAssociation" {
  for_each      = aws_subnet.myPrivateSubnets
  route_table_id = aws_route_table.myPrivateTable.id
  subnet_id      = each.value.id
}


//global module

# Existing network resources here...

# Call the webserver module
module "webserver" {
  source         = "../webserver module"  # Path to the webserver module

  vpcId          = aws_vpc.myVpc.id
  publicSubnets  = [for s in aws_subnet.myPublicSubnets : s.id]

  amiId          = var.amiId       # Add these to the network module's variables.tf
  instanceType   = var.instanceType
  desiredCapacity = var.desiredCapacity
  maxSize        = var.maxSize
  minSize        = var.minSize
  allowedHttpIps = var.allowedHttpIps
  allowedSshIps  = var.allowedSshIps
  environment    = var.environment
}

