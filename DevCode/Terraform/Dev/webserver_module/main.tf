provider "aws" {
  region = "us-east-1"
}

module "dev-webserver" {
  source = "../../MainModule/webserver_module/"
  env    = "dev"
}