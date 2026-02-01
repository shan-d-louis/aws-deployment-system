variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "ecr_url" {
  type = string
}

variable "image_tag" {
  default = "latest"
  type    = string
}

variable "app_port" {
  type = number
}

variable "number_of_instances" {
  type = number
}

variable "target_group_arn" {
  type = string
}

variable "subnet_id" {
    type = list(string)
}