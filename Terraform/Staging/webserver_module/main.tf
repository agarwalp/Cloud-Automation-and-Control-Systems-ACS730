provider "aws" {
  region = "us-east-1"
}

module "staging-network" {
  source = "../../MainModule/webserver_module" # Path to the module
  env    = "staging"
}
