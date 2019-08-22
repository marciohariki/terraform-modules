variable "project" {}

variable "env" {}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_escale" {
  default = 6
}

variable "region" {}

data "aws_availability_zones" "available" {}