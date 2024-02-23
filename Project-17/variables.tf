variable "region" {
  type        = string
  description = "The region to deploy resources"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC cidr"
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_classiclink" {
  type = bool
}

variable "enable_classiclink_dns_support" {
  type = bool
}

variable "preferred_number_of_public_subnets" {
  # default =null
  type        = number
  description = "Number of public subnets"
}

variable "preferred_number_of_private_subnets" {
  # default = null
  type        = number
  description = "Number of private subnets"
}

variable "name" {
  type    = string
  default = "savvytek"

}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "environment" {
  type        = string
  description = "Environment"

}

variable "ami" {
  type        = string
  description = "AMI ID for the launch template"
}


variable "keypair" {
  type        = string
  description = "key pair for the instances"
}

variable "account_no" {
  type        = number
  description = "the aws account number"
}


variable "master-username" {
  type        = string
  description = "RDS admin username"
}

variable "master-password" {
  type        = string
  description = "RDS master password"
}