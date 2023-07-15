variable "vpc" {
  type        = map(string)
  description = "Configuration of VPC"
  default = {
    name        = "AWX"
    description = "AWX VPC"
    region      = "ams3"
  }
}

variable "project" {
  type        = map(string)
  description = "Project configuration"
  default = {
    description = "Test project for AWX K8s"
    environment = "development"
    name        = "AWX_project"
    purpose     = "personal"
  }
}
