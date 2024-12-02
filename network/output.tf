output "vpcId" {
  value = aws_vpc.myVpc.id
}

output "privateSubnetIds" {
  value = [for s in aws_subnet.myPrivateSubnets : s.id]
}

output "privateCidrBlocks" {
  value = var.privateCidrs
}


output "publicSubnetIds" {
  value = [for s in aws_subnet.myPublicSubnets : s.id]
}

output "publicCidrBlocks" {
  value = var.publicCidrs
}


output "internetGatewayId" {
  value = aws_internet_gateway.myInternetGateway.id
}


output "natGatewayId" {
  value = aws_nat_gateway.myNatGateway.id
}

output "natGatewayEip" {
  value = aws_eip.myNatGatewayEip.id
}

output "publicRouteTableId" {
  value = aws_route_table.myPublicTable.id
}

output "privateRouteTableId" {
  value = aws_route_table.myPrivateTable.id
}


