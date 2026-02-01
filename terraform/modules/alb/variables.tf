variable "project_name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "environment" {
  type = string
}

variable "app_port" {
  type = number
}

variable "vpc_id" {
  type = string
}