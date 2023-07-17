terraform {
  backend "consul" {
    path = "terraform/modules/digitalocean-awx/simple"
  }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.8"
    }

    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.28"
    }
  }
}

data "vault_kv_secret_subkeys_v2" "do_token" {
  mount = "digitalocean"
  name  = "tokens"
}

data "vault_generic_secret" "do_token" {
  path = "digitalocean/tokens"
}

provider "digitalocean" {
  # token = data.vault_kv_secret_subkeys_v2.do_token.data["terraform"]
  token = data.vault_generic_secret.do_token.data["terraform"]
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
  depends_on   = [module.vpc]
  source       = "brucellino/kubernetes/digitalocean"
  version      = "2.0.2"
  vpc_name     = var.vpc.name
  project_name = var.project.name
  cluster_name = var.cluster_name
  k8s_version  = "1.24."
  node_pools = {
    awx = {
      size       = "s-2vcpu-2gb"
      node_count = 3
      labels = {
        name = "awx-executor"
      }
      tags  = ["awx-executor"]
      taint = {}
    }
  }
}

data "digitalocean_kubernetes_cluster" "selected" {
  depends_on = [module.k8s]
  name       = var.cluster_name
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.selected.endpoint
  token = data.digitalocean_kubernetes_cluster.selected.kube_config.0.token
  # client_certificate     = base64decode(data.digitalocean_kubernetes_cluster.selected.kube_config.0.client_certificate)
  # client_key             = base64decode(data.digitalocean_kubernetes_cluster.selected.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.selected.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host = data.digitalocean_kubernetes_cluster.selected.endpoint
    # client_certificate     = base64decode(data.digitalocean_kubernetes_cluster.selected.kube_config.0.client_certificate)
    # client_key             = base64decode(data.digitalocean_kubernetes_cluster.selected.kube_config.0.client_key)
    token                  = data.digitalocean_kubernetes_cluster.selected.kube_config.0.token
    cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.selected.kube_config.0.cluster_ca_certificate)
  }
}

module "example" {
  source       = "../../"
  depends_on   = [module.k8s]
  project_name = var.project.name
  vpc_name     = var.vpc.name
  cluster_name = var.cluster_name
}
