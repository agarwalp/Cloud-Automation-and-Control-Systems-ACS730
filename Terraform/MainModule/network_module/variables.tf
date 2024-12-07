variable "env" {
  type        = string
  description = "Deployment Environment"
}

variable "vpcCidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "publicCidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
}

variable "privateCidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["10.1.5.0/24", "10.1.6.0/24"]
}

