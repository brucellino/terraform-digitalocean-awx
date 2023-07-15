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
module "vpc" {
  source          = "brucellino/vpc/digitalocean"
  version         = "1.0.3"
  vpc_description = var.vpc.description
  vpc_name        = var.vpc.name
  vpc_region      = var.vpc.region
  project         = var.project
}

module "k8s" {
  source       = "brucellino/kubernetes/digitalocean"
  version      = "2.0.0"
  vpc_name     = var.vpc.name
  project_name = var.project.name
}

module "example" {
  source = "../../"
}
