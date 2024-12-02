variable "environment" {
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


//for global module

# Webserver-specific variables
/*
variable "amiId" {
  description = "AMI ID for the webserver"
  type        = string
  default     = "ami-0c02fb55956c7d316"  
}

variable "instanceType" {
  description = "Instance type for the webserver"
  type        = string
   default     = "t2.micro"
}

variable "desiredCapacity" {
  description = "Desired capacity for ASG"
  type        = number
  default  =   1
}

variable "maxSize" {
  description = "Max size for ASG"
  type        = number
  default     = 4
}

variable "minSize" {
  description = "Min size for ASG"
  type        = number
  default     = 1
}

variable "allowedHttpIps" {
  description = "Allowed IP ranges for HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowedSshIps" {
  description = "Allowed IP ranges for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
*/