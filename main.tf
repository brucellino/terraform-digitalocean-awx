# Project
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

# Redis DB -- operator doesn't seem to handle that.

# conection string

# vault mount

# vault role


# resource "helm_release" "redis" {
#   name = "my-redis-release"
#   # repository = "https://charts.bitnami.com/bitnami"
#   # chart      = "redis"
#   # version    = "17.13.1"
#   chart = "https://charts.bitnami.com/bitnami/redis-10.7.16.tgz"

#   values = [
#     "${file("${path.module}/files/redis-values.yaml")}"
#   ]

#   set {
#     name  = "cluster.enabled"
#     value = "true"
#   }

#   set {
#     name  = "metrics.enabled"
#     value = "true"
#   }

#   set {
#     name  = "service.annotations.prometheus\\.io/port"
#     value = "9127"
#     type  = "string"
#   }
# }
