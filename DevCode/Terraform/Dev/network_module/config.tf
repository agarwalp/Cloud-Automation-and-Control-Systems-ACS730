terraform {
  backend "s3" {
    bucket = "group1-acs730finalproject-dev"        # S3 bucket to SAVE Terraform State
    key    = "dev/network_module/terraform.tfstate" # Object key for network state
    region = "us-east-1"                            # Region where bucket is created
  }
}