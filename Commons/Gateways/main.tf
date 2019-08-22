provider "aws" {
  region = "${var.region}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  tags {
    Name = "${var.project}_igw_${var.env}"
    env  = "${var.env}"
    Type = "Gateway"
  }
}

resource "aws_eip" "eip_nat_gw" {
  vpc = true

  tags {
    Name = "${var.project}_eip_${var.env}"
    env  = "${var.env}"
    Type = "Gateway-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.eip_nat_gw.id}"
  subnet_id     = "${data.terraform_remote_state.vpc.subnet_public_igw_ids[0]}"

  tags {
    Name = "${var.project}_nat_${var.env}"
    env  = "${var.env}"
    Type = "Gateway"
  }
}