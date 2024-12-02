variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpcId" {
  description = "VPC ID"
  type        = string
}

variable "publicSubnets" {
  description = "Public subnet IDs"
  type        = list(string)
}

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
  default  =   4
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

variable "environment" {
  description = "Environment name"
  type        = string
}


