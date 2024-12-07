terraform {
  required_version = ">= 1.3.0" # Specify the required Terraform version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0" # Specify the AWS provider version
    }
  }

  backend "s3" {
    bucket = "group1-acs730finalproject-staging"         
    key    = "staging/webserver_module/terraform.tfstate" # Key for state file
    region = "us-east-1"                                  # Region for the S3 bucket
  }
}
