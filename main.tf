provider "aws" {
  region = var.aws_region
}

locals {
  defaultTags = {
    Project     = "ACS730-Group1"
    ManagedBy   = "Terraform"
    Environment = var.environment
  }
}

module "production_network" {
  source               = "../network_module" 
  environment          = var.environment
  vpcCidr              = var.vpcCidr
  publicCidrs          = var.publicCidrs
  privateCidrs         = var.privateCidrs
  # tags                 = local.defaultTags 
}
