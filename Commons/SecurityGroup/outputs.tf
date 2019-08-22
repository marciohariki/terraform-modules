output "sg_private_level_1_id" {
  value = "${aws_security_group.sg_private_level_1.id}"
}

output "sg_private_level_2_id" {
  value = "${aws_security_group.sg_private_level_2.id}"
}

output "sg_public_id" {
  value = "${aws_security_group.sg_public.id}"
}
