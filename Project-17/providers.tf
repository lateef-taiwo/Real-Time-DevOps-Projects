
provider "aws" {
  region = var.region

  shared_credentials_files = ["$HOME/.aws/credentials"]
  shared_config_files = ["$HOME/.aws/config"]
  profile = "default"
}