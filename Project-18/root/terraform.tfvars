region = "us-east-1"


vpc_cidr = "172.16.0.0/16"


enable_dns_support = "true"


enable_dns_hostnames = "true"


enable_classiclink = "false"


enable_classiclink_dns_support = "false"


preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

environment = "dev"

ami = "ami-08900fdabfe86d539"

account_no = "005654795190"

keypair = "servers"

master-username = "savvytekadmin"

master-password = "admin12345"

tags = {
  Enviroment      = "production"
  Owner-Email     = "savvy@savvytech.io"
  Managed-By      = "Abdul"
  Billing-Account = "1234567890"
}
