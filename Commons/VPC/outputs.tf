output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_public_igw_ids" {
  value = "${aws_subnet.public_igw.*.id}"
}

output "subnet_public_nat_ids" {
  value = "${aws_subnet.public_nat.*.id}"
}

output "subnet_private_nat_ids" {
  value = "${aws_subnet.private_nat.*.id}"
}