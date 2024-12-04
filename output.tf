output "vpc_id" {
  value       = module.production_network.vpcId
  description = "The ID of the VPC for the production environment"
}

output "public_subnet_ids" {
  value       = module.production_network.publicSubnetIds
  description = "The IDs of the public subnets for the production environment"
}

output "private_subnet_ids" {
  value       = module.production_network.privateSubnetIds
  description = "The IDs of the private subnets for the production environment"
}

output "internet_gateway_id" {
  value       = module.production_network.internetGatewayId
  description = "The ID of the Internet Gateway for the production environment"
}

output "nat_gateway_id" {
  value       = module.production_network.natGatewayId
  description = "The ID of the NAT Gateway for the production environment"
}

output "public_route_table_id" {
  value       = module.production_network.publicRouteTableId
  description = "The ID of the public route table for the production environment"
}

output "private_route_table_id" {
  value       = module.production_network.privateRouteTableId
  description = "The ID of the private route table for the production environment"
}
