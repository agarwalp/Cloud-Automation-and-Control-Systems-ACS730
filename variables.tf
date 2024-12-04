variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

#variable "availability_zones" {
 #description = "Availability zones for subnets."
 #type        = list(string)
 #default     = ["us-east-1a", "us-east-1b","us-east-1c]
#}


variable "environment" {
  type        = string
  description = "Production env"
  default     = "prod"
}

variable "vpcCidr" {
  type        = string
  description = "VPC's CIDR block "
  default     = "10.4.0.0/16" 
}

variable "publicCidrs" {
  type        = list(string)
  description = "Public subnet's CIDR blocks"
  default     = ["10.4.1.0/24", "10.4.2.0/24", "10.4.3.0/24"]
}

variable "privateCidrs" {
  type        = list(string)
  description = " private subnet's CIDR block"
  default     = ["10.4.4.0/24", "10.4.5.0/24"]
}
