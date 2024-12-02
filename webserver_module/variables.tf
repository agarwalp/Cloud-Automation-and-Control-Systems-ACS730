variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "amiId" {
  description = "AMI ID for the webserver"
  type        = string
  default     = "ami-0453ec754f44f9a4a"
}

variable "instanceType" {
  description = "Instance type for the webserver"
  type        = string
  default     = "t2.micro"
}

variable "desiredCapacity" {
  description = "Desired capacity for the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "maxSize" {
  description = "Maximum size for the Auto Scaling Group"
  type        = number
  default     = 4
}

variable "minSize" {
  description = "Minimum size for the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "key_pair_name" {
  description = "The name of key pair to use for SSH access."
  type        = string
  default     = "vockey"
}