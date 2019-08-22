data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket  = "${var.bucket_state}"
    key     = "env:/${var.env_infra}/${var.vpc_state_key_name}"
    region  = "${var.region}"
    encrypt = "true"
  }
}

data "terraform_remote_state" "security_group" {
  backend = "s3"
  config {
    bucket  = "${var.bucket_state}"
    key     = "env:/${var.env_infra}/${var.security_group_state_key_name}"
    region  = "${var.region}"
    encrypt = "true"
  }
}