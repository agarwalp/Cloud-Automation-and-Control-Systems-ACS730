provider "aws" {
  region = "us-east-1"
}


module "dev-network" {
  source = "../../MainModule/network_module" # Path to the module
  env    = "dev"
}
