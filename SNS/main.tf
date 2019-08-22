provider "aws" {
  region = "${var.region}"
}

resource "aws_sns_topic" "topic" {
  name                          = "${format("%s_%s", var.desc, var.env)}"
  display_name                  = "${var.display_name}"
}
