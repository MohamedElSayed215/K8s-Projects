variable "region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "AWS SSH Key Pair Name"
}

variable "my_ip" {
  description = "Your public IP in CIDR"
}





variable "subnet_ids" {
  type = list(string)
}

variable "db_password" {
  description = "The password for the RDS database"
  type        = string
  sensitive   = true
  default     = "Admin123789" 
}

variable "db_username" {
  default = "admin"
}