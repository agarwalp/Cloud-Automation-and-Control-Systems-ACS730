provider "aws" {
  region = "us-east-1"
}


module "prod-network" {
  source = "../../MainModule/network_module" # Path to the module
  env    = "prod"
}


