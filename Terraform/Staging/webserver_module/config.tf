terraform {
  backend "s3" {
    bucket = "group1-acs730finalproject-staging"          # S3 bucket to SAVE Terraform State
    key    = "staging/webserver_module/terraform.tfstate" # Object key for network state
    region = "us-east-1"                                  # Region where bucket is created
  }
}