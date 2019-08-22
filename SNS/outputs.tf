output "sns_arn" {
  value = ["${aws_sns_topic.topic.arn}"]
}

output "sns_id" {
  value = ["${aws_sns_topic.topic.id}"]
}