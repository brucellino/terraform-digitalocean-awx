# variables.tf
variable "project_name" {
  description = "Name of the digitalocean project to assign resources to"
  type        = string
}

variable "vpc_name" {
  description = "Name of the Digitalocean VPC to be used when creating resources"
  type        = string
}

variable "pg_cluster_node_count" {
  type        = number
  description = "Number of nodes in the postgres cluster"
  # add check that it should be greater than 0
  default = 1
}

variable "db_size" {
  description = "Size of the DB instances"
  type        = string
  default     = "db-s-1vcpu-1gb"
  # add check - should be in https://docs.digitalocean.com/reference/api/api-reference/#tag/Databases
}


variable "cluster_name" {
  description = "Name of k8s cluster to deploy into"
  type        = string
}
