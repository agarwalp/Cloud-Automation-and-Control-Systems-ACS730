provider "aws" {
  region = "us-east-1"
}

module "prod-webserver" {
  source = "../../MainModule/webserver_module/"
  env    = "prod"
}

