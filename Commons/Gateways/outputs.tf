output "aws_internet_gateway_id" {
  value = "${aws_internet_gateway.igw.id}"
}
output "aws_eip_id" {
  value = "${aws_eip.eip_nat_gw.id}"
}

output "aws_nat_id" {
  value = "${aws_nat_gateway.nat.id}"
}