provider "aws" {
  region = "${var.region}"
}

resource "aws_route_table" "to-igw" {
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${data.terraform_remote_state.gateways.aws_internet_gateway_id}"
  }

  tags {
    Name = "${var.project}_routetables_to-igw_${var.env}"
    env  = "${var.env}"
    Type = "RouteTable"
  }
}

resource "aws_route_table" "to-nat" {
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${data.terraform_remote_state.gateways.aws_nat_id}"
  }

  tags {
    Name = "${var.project}_routetables_to-nat_${var.env}"
    env  = "${var.env}"
    Type = "RouteTable"
  }
}

resource "aws_route_table_association" "private_nat_association" {
  count          = "${length(data.terraform_remote_state.vpc.subnet_private_nat_ids)}"
  subnet_id      = "${element(data.terraform_remote_state.vpc.subnet_private_nat_ids, count.index)}"
  route_table_id = "${aws_route_table.to-nat.id}"
}

resource "aws_route_table_association" "public_nat_association" {
  count          = "${length(data.terraform_remote_state.vpc.subnet_public_nat_ids)}"
  subnet_id      = "${element(data.terraform_remote_state.vpc.subnet_public_nat_ids, count.index)}"
  route_table_id = "${aws_route_table.to-nat.id}"
}

resource "aws_route_table_association" "public_igw_association" {
  count          = "${length(data.terraform_remote_state.vpc.subnet_public_igw_ids)}"
  subnet_id      = "${element(data.terraform_remote_state.vpc.subnet_public_igw_ids, count.index)}"
  route_table_id = "${aws_route_table.to-igw.id}"
}
