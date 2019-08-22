output "aws_ec2_instance_profile_name" {
  value = "${aws_iam_instance_profile.ec2_instance_profile.name}"
}

output "aws_ec2_instance_profile_id" {
  value = "${aws_iam_instance_profile.ec2_instance_profile.id}"
}

output "aws_ec2_instance_profile_arn" {
  value = "${aws_iam_instance_profile.ec2_instance_profile.arn}"
}