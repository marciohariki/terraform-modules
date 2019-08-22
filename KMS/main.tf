provider "aws" {
  region = "${var.region}"
}
resource "aws_kms_key" "KMS" {
  description = "${var.project}_key_${var.env}"

  tags {
    Name = "${var.project}_key_${var.env}"
    env  = "${var.env}"
    Type = "KMS"
  }
}

resource "aws_kms_alias" "KMS_ALIAS" {
  name          = "alias/${var.project}_key_${var.env}"
  target_key_id = "${aws_kms_key.KMS.key_id}"
}