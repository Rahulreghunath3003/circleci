variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
  }

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
}

variable "name" {
  description = "Name for tagging resources"
  type        = string
  default = "circleci"
}
