variable "project" {}

variable "env" {}

variable "region" {}

variable "instance_type" {}

variable "ami_id" {}

variable "env_infra" {
  description = "Infrastructure environment (dev, homolog, prod)."
}

variable "bucket_state" {}

variable "vpc_state_key_name" {}

variable "security_group_state_key_name" {}

variable "ec2_state_key_name" {}

variable "valid_until" {}

variable "target_capacity" {}

variable "key_name" {
  description = "Key-pair name to use to connect using ssh (default: kroton-prod-key-pair)."
  default = "kroton-prod-key-pair"
}


data "aws_availability_zones" "available" {}