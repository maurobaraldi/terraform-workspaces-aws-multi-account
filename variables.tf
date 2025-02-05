# Global definitions

variable "env_name" {
    type = string
    description = "Environment full name"
}

variable "env_prefix" {
    type = string
    description = "Environment name prefix"
}

variable "vpc_cidr_block" {
    type = string
    description = "The IPv4 CIDR block for the VPC"
}

variable "subnet_cidr_block" {
    type = string
    description = "The IPv4 CIDR block for the subnet"
}

variable "small_instance" {
    type = string
    description = "EC2 small instance."
}
