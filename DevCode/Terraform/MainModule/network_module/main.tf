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
    Environment = var.env
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
      Name = "${var.env}VPC"
    }
  )
}

resource "aws_subnet" "myPublicSubnets" {
  for_each = {
    for idx, cidr in var.publicCidrs :
    idx => cidr
  }

  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = each.value
  availability_zone       = element(data.aws_availability_zones.available.names, each.key % length(data.aws_availability_zones.available.names))
  map_public_ip_on_launch = true

  tags = merge(
    local.defaultTags,
    {
      Name = "${var.env}PublicSubnet${each.key + 1}"
    }
  )
}



resource "aws_subnet" "myPrivateSubnets" {
  for_each                = toset(var.privateCidrs)
  vpc_id                  = aws_vpc.myVpc.id
  cidr_block              = each.value
  availability_zone       = element(data.aws_availability_zones.available.names, index(var.privateCidrs, each.value))
  map_public_ip_on_launch = false
  tags = merge(
    local.defaultTags,
    {
      Name = "${var.env}PrivateSubnet${index(var.privateCidrs, each.value) + 1}"
    }
  )
}

resource "aws_nat_gateway" "myNatGateway" {
  allocation_id = aws_eip.myNatGatewayEip.id
  subnet_id     = values(aws_subnet.myPublicSubnets)[0].id
  tags = merge(
    local.defaultTags,
    {
      Name = "${var.env}NatGateway"
    }
  )
}

resource "aws_eip" "myNatGatewayEip" {
  domain = "vpc"
  tags = {
    Name = "${var.env}NatGatewayEIP"
  }
  depends_on = [aws_internet_gateway.myInternetGateway]
}

resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = aws_vpc.myVpc.id
  tags = merge(
    local.defaultTags,
    {
      Name = "${var.env}InternetGateway"
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
      Name = "${var.env}PrivateRouteTable"
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
    Name = "${var.env}PublicRouteTable"
  }
}

resource "aws_route_table_association" "myPublicTableAssociation" {
  for_each       = aws_subnet.myPublicSubnets
  route_table_id = aws_route_table.myPublicTable.id
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "myPrivateTableAssociation" {
  for_each       = aws_subnet.myPrivateSubnets
  route_table_id = aws_route_table.myPrivateTable.id
  subnet_id      = each.value.id
}


