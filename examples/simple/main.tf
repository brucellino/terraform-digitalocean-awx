# This is the default example
# provider "aws" {
#
# }

# Declare your backends and other terraform configuration here
terraform {
  backend "consul" {
    path = "terraform/modules/digitalocean-awx/simple"
  }
}


module "example" {
  source = "../../"
}
