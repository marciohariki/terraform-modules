data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket  = "${var.bucket_state}"
    key     = "env:/${var.env}/${var.vpc_state_key_name}"
    region  = "${var.region}"
    encrypt = "true"
  }
}