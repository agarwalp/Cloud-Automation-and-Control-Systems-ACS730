output "vpcId" {
  value       = module.staging-network.vpcId
  description = "The ID of the VPC for the staging environment"
}

output "publicSubnetIds" {
  value       = module.staging-network.publicSubnetIds
  description = "The IDs of the public subnets for the staging environment"
}

output "privateSubnetIds" {
  value       = module.staging-network.privateSubnetIds
  description = "The IDs of the private subnets for the staging environment"
}

output "publicRouteTableId" {
  value       = module.staging-network.publicRouteTableId
  description = "The ID of the public route table for the staging"
}

output "privateRouteTableId" {
  value       = module.staging-network.privateRouteTableId
  description = "The ID of the private route table for the staging environment"
}
