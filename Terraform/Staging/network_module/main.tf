provider "aws" {
  region = "us-east-1"
}


module "staging-network" {
  source = "../../MainModule/network_module" # Path to the module
  env    = "staging"
}
