terraform {
  required_version = ">= 1.3.0" 

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0" 
    }
  }
  
  provider "aws" {
  region = "us-east-1"
}
module "staging-network" {
  source = "../../MainModule/network_module" # Path to the module
  env    = "staging"
}
