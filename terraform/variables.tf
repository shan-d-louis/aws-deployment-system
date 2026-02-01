variable "project_name" {
  type    = string
  default = "nameless-project"
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "app_port" {
  type    = number
  default = 3000
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "number_of_instances" {
  type    = number
  default = 1
}

variable "github_username" {
    type = string
    default = "test-username"  
}

variable "github_repo" {
    type = string
    default = "test-repo"  
}