terraform {
  backend "s3" {
    bucket = "acs730finalproj-dev"                              # S3 bucket to SAVE Terraform State
    key    = "environment/dev/network_module/terraform.tfstate" # Object key for network state
    region = "us-east-1"                                        # Region where bucket is created
  }
}