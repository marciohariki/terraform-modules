provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name = "${var.project}_vpc_${var.env}"
    env  = "${var.env}"
    Type = "VPC"
  }
}

resource "aws_subnet" "public_igw" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}", "${var.subnet_escale}", count.index+1)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.project}_subnet_public_igw_${data.aws_availability_zones.available.names[count.index]}_${var.env}"
    env  = "${var.env}"
    Tier = "Public-Igw"
    Type = "VPC-Subnet"
  }
}

resource "aws_subnet" "public_nat" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}",
                            "${var.subnet_escale}",
                            "${length(data.aws_availability_zones.available.names)}" + count.index+1)}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.project}_subnet_public_nat_${data.aws_availability_zones.available.names[count.index]}_${var.env}"
    env  = "${var.env}"
    Tier = "Public-Nat"
    Type = "VPC-Subnet"
  }
}

resource "aws_subnet" "private_nat" {
  count                   = "${length(data.aws_availability_zones.available.names)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr}",
                            "${var.subnet_escale}",
                            ("${length(data.aws_availability_zones.available.names)}"*2) + count.index+1)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${var.project}_subnet_private_${data.aws_availability_zones.available.names[count.index]}_${var.env}"
    env  = "${var.env}"
    Tier = "Private"
    Type = "VPC-Subnet"
  }
}