variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "staging_public_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "prod_public_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

data "aws_availability_zones" "available" {}
