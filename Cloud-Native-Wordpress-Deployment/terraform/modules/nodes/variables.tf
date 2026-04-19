variable "vpc_id" {
  type        = string
  description = "The VPC ID where the nodes will be created"
}

variable "public_subnet_id" {
  type        = string
  description = "The subnet ID for the master node"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}