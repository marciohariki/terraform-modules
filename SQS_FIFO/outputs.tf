output "fifo_queue_arn" {
  value = ["${aws_sqs_queue.fifo_queue.*.arn}"]
}

output "fifo_queue_id" {
  value = ["${aws_sqs_queue.fifo_queue.*.id}"]
}