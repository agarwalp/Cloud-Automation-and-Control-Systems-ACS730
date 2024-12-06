output "vpcId" {
  value       = module.dev-network.vpcId
  description = "The ID of the VPC for the dev environment"
}

output "publicSubnetIds" {
  value       = module.dev-network.publicSubnetIds
  description = "The IDs of the public subnets for the dev environment"
}

output "privateSubnetIds" {
  value       = module.dev-network.privateSubnetIds
  description = "The IDs of the private subnets for the dev environment"
}

output "publicRouteTableId" {
  value       = module.dev-network.publicRouteTableId
  description = "The ID of the public route table for the dev environment"
}

output "privateRouteTableId" {
  value       = module.dev-network.privateRouteTableId
  description = "The ID of the private route table for the dev environment"
}
