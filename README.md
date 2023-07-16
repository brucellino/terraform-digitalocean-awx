[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit) [![pre-commit.ci status](https://results.pre-commit.ci/badge/github/brucellino/terraform-digitalocean-awx/main.svg)](https://results.pre-commit.ci/latest/github/brucellino/terraform-digitalocean-awx/main) [![semantic-release: conventional](https://img.shields.io/badge/semantic--release-conventional-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

# Terraform module for AWX on DigitalOcean

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.28 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.28.1 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.10.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_database_cluster.awx_pg](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_cluster) | resource |
| [digitalocean_database_firewall.k8s](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_firewall) | resource |
| [digitalocean_database_user.awx_admin](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_user) | resource |
| [helm_release.redis](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [digitalocean_kubernetes_cluster.selected](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/kubernetes_cluster) | data source |
| [digitalocean_project.awx](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/project) | data source |
| [digitalocean_vpc.awx](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of k8s cluster to deploy into | `string` | n/a | yes |
| <a name="input_db_size"></a> [db\_size](#input\_db\_size) | Size of the DB instances | `string` | `"db-s-1vcpu-1gb"` | no |
| <a name="input_pg_cluster_node_count"></a> [pg\_cluster\_node\_count](#input\_pg\_cluster\_node\_count) | Number of nodes in the postgres cluster | `number` | `1` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of the digitalocean project to assign resources to | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the Digitalocean VPC to be used when creating resources | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
