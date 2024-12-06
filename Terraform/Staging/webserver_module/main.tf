provider "aws" {
  region = "us-east-1"
}

module "staging-webserver" {
  source = "../../MainModule/webserver_module/"
  env    = "staging"
}