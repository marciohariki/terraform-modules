provider "aws" {
  region = "${var.region}"
}

resource "aws_sqs_queue" "fifo_queue" {
  name                          = "${format("%s_%s.fifo", var.desc, var.env)}"
  fifo_queue                    = true
  content_based_deduplication   = "${var.content_based_deduplication}"
  delay_seconds                 = "${var.delay_seconds}"
  visibility_timeout_seconds    = "${var.visibility_timeout_seconds}"
  message_retention_seconds     = "${var.message_retention_seconds}"

   tags {
    Name = "${format("%s_%s.fifo", var.desc, var.env)}"
    env  = "${var.env}"
    Type = "SQS"
  }
}
