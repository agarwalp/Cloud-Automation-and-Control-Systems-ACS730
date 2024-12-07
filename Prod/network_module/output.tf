output "vpcId" {
  value       = module.prod-network.vpcId
  description = "The ID of the VPC for the prod environment"
}

output "publicSubnetIds" {
  value       = module.prod-network.publicSubnetIds
  description = "The IDs of the public subnets for the prod environment"
}

output "privateSubnetIds" {
  value       = module.prod-network.privateSubnetIds
  description = "The IDs of the private subnets for the prod environment"
}

output "publicRouteTableId" {
  value       = module.prod-network.publicRouteTableId
  description = "The ID of the public route table for the prod environment"
}

output "privateRouteTableId" {
  value       = module.prod-network.privateRouteTableId
  description = "The ID of the private route table for the prod environment"
}
