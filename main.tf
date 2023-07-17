# Project
data "digitalocean_certificate" "selected" {
  name = "cert"
}

data "digitalocean_project" "awx" {
  name = var.project_name
}

data "digitalocean_vpc" "awx" {
  name = var.vpc_name
}
# Postgres database
resource "digitalocean_database_cluster" "awx_pg" {
  name       = "awx-pg"
  engine     = "pg"
  version    = "15"
  tags       = ["awx"]
  node_count = var.pg_cluster_node_count
  project_id = data.digitalocean_project.awx.id
  region     = data.digitalocean_vpc.awx.region
  size       = var.db_size
}

data "digitalocean_kubernetes_cluster" "selected" {
  name = var.cluster_name
}

resource "digitalocean_database_firewall" "k8s" {
  cluster_id = digitalocean_database_cluster.awx_pg.id

  rule {
    type  = "k8s"
    value = data.digitalocean_kubernetes_cluster.selected.id
  }
}


resource "digitalocean_database_user" "awx_admin" {
  cluster_id = digitalocean_database_cluster.awx_pg.id
  name       = "awx"
}
# conection string

# vault mount

# vault role

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  set {
    name  = "controller.publishService.enabled"
    value = true
  }

  set {
    name  = "installCRDs"
    value = true
  }
}

locals {
  awx_resources = {
    namespace = "namespace.yml"
  }
}


# resource "kubernetes_manifest" "awx" {
#   depends_on = [data.digitalocean_kubernetes_cluster.selected]
#   for_each   = local.awx_resources
#   manifest   = yamldecode(file("${path.module}/files/awx/${each.value}"))
# }

resource "kubernetes_namespace_v1" "awx" {
  metadata {
    name = "awx"
    labels = {
      control-plane = "controller-manager"
    }
  }
}
# resource "kubernetes_ingress_v1" "awx" {
#   wait_for_load_balancer = true
#   metadata {
#     name = "awx"
#     annotations = {
#       "kubernetes.io/ingress.class" = "nginx"
#     }
#   }
#   spec {
#     rule {
#       host = "awx.brucellino.dev"
#       http {
#         path {
#           path = "/"
#           backend {
#             service {
#               name = kubernetes_service.hello_world.metadata.0.name
#               port {
#                 number = 8080
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
