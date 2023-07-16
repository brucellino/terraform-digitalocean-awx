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


resource "digitalocean_database_user" "awx_admin" {
  cluster_id = digitalocean_database_cluster.awx_pg.id
  name       = "awx"
}
# conection string

# vault mount

# vault role


resource "helm_release" "redis" {
  name       = "my-redis-release"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "awx-operator/awx-operator"
  version    = "2.4.0"

  # set {
  #   name  = "cluster.enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "metrics.enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "service.annotations.prometheus\\.io/port"
  #   value = "9127"
  #   type  = "string"
  # }
}
