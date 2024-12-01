variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags"
}

variable "instance_type" {

  description = "Type of the instance"
  type        = string
}

variable "env" {

  type        = string
  description = "Deployment Environment"
}

#Minimum number of EC2 atleast present
variable "minimum_size" {

  type        = number
  description = "Minimum capacity"
}

#Desired number of EC2 in auto scaling group
variable "desired_size" {

  type        = number
  description = "Desired capacity"
}

#Minimum number of EC2 instances that can spinned up
variable "maximum_size" {

  type        = number
  description = "Maximum capacity"
}

variable "path_to_ssh_key" {

  description = "Path to the public ssh key"
  type        = string
}