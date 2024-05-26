

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  # enable_classiclink             = var.enable_classiclink
  # enable_classiclink_dns_support = var.enable_dns_support


  tags = merge(
    var.tags,
    {
      Name = format("%s-VPC", var.name)
    },
  )
}

# Get list of availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]



  tags = merge(
    var.tags,
    {
      Name = format("%s-PublicSubnet-%s", var.name, count.index)
    },
  )

}

# Create private subnets
resource "aws_subnet" "private" {
  count                   = var.preferred_number_of_private_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_private_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.tags,
    {
      Name = format("%s-PrivateSubnet-%s", var.name, count.index)
    },
  )

}

# provider "aws" {
#   region = "eu-central-1"
# }

# # Create VPC
# resource "aws_vpc" "main" {
#   cidr_block                     = "172.16.0.0/16"
#   enable_dns_support             = "true"
#   enable_dns_hostnames           = "true"
#   #enable_classiclink             = "false"
#   #enable_classiclink_dns_support = "false"

# }

# # Create public subnets1
#     resource "aws_subnet" "public1" {
#     vpc_id                     = aws_vpc.main.id
#     cidr_block                 = "172.16.0.0/24"
#     map_public_ip_on_launch    = true
#     availability_zone          = "eu-central-1a"


# }


# # Create public subnet2
#     resource "aws_subnet" "public2" {
#     vpc_id                     = aws_vpc.main.id
#     cidr_block                 = "172.16.1.0/24"
#     map_public_ip_on_launch    = true
#     availability_zone          = "eu-central-1b"
# }
