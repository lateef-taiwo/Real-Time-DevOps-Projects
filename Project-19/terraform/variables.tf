variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "172.20.0.0/24"
}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
  default = "true"
}


variable "preferred_number_of_public_subnets" {
  type        = number
  description = "Number of public subnets"
}

variable "preferred_number_of_private_subnets" {
  type        = number
  description = "Number of private subnets"
}

variable "name" {
  type    = string
  default = "TCS"

}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}

}

variable "environment" {
  type        = string
  description = "environment"

}


variable "ami-bastion" {
  type        = string
  description = "AMI ID for the launch template"
}


variable "ami-web" {
  type        = string
  description = "AMI ID for the launch template"
}


variable "ami-nginx" {
  type        = string
  description = "AMI ID for the launch template"
}


variable "ami-sonar" {
  type        = string
  description = "AMI ID for the launch template"
}



variable "keypair" {
  type        = string
  description = "keypair  for instances"

}

variable "account_no" {
  type        = number
  description = "the account number"
}


variable "master-username" {
  type        = string
  description = "RDS admin username"
}

variable "master-password" {
  type        = string
  description = "RDS master password"
}



