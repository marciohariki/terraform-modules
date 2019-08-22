variable "project" {
  description = "Description of the project (ex: kroton-analytics)."
}

variable "env" {
  description = "Environment (dev, homolog, prod)."
}

variable "env_infra" {
  description = "Infrastructure environment (dev, homolog, prod)."
}

variable "region" {
  description = "AWS region to use (default: us-east-1)."
}

variable "bucket_state" {
  description = "S3 bucket where the state files are stored."
}

variable "vpc_state_key_name" {
  description = "State file key name for VPC module."
}

variable "security_group_state_key_name" {
  description = "State file key name for SecurityGroup module."
}

variable "desc" {
    description = "Project name (also the git repository name)."
}

variable "key_name" {
  description = "Key-pair name to use to connect using ssh (default: kroton-prod-key-pair)."
  default = "kroton-prod-key-pair"
}

variable "instance_type" {
    description = "EC2 instance type."
}

variable "project_bucket" {
    description = "S3 bucket where the project files are located."
}

variable "ssh_bucket" {
  description = "S3 bucket where the ssh private key for github is located."
}

variable "ssh_key" {
  description = "S3 keypath where the ssh private key for github is located."
}

variable "git_repository" {
  description = "Prefix of Git URL where the project is (ex: git@github.com:<git_root>)"
}

variable "git_branch" {
  description = "Git branch to use for the project."
}
