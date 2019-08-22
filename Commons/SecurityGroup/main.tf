provider "aws" {
  region = "${var.region}"
}

########### Private level 2
resource "aws_security_group" "sg_private_level_2" {
  name                   = "${format("%s_sg_private_level_2_%s", var.project, var.env)}"
  description            = "${var.project} Private Level 2"
  vpc_id                 = "${data.terraform_remote_state.vpc.vpc_id}"
  revoke_rules_on_delete = true

  tags {
    Name = "${format("%s_sg_private_level_2_%s", var.project, var.env)}"
    env  = "${var.env}"
    Type = "SecurityGroup"
  }
}

resource "aws_security_group_rule" "private_level_2_ingress_http" {
  type              = "ingress"
  count             = 1
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.sg_private_level_1.id}"
  description       = "${aws_security_group.sg_private_level_1.name}"
  security_group_id = "${aws_security_group.sg_private_level_2.id}"
}


resource "aws_security_group_rule" "private_level_2_ingress_https" {
  type              = "ingress"
  count             = 1
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.sg_private_level_1.id}"
  description       = "${aws_security_group.sg_private_level_1.name}"
  security_group_id = "${aws_security_group.sg_private_level_2.id}"
}

resource "aws_security_group_rule" "private_level_2_ingress_ssh" {
  type              = "ingress"
  count             = 1
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.sg_private_level_1.id}"
  description       = "${aws_security_group.sg_private_level_1.name}"
  security_group_id = "${aws_security_group.sg_private_level_2.id}"
}

resource "aws_security_group_rule" "private_level_2_ingress_security_group" {
  type                     = "ingress"
  count                    = 1
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = "${aws_security_group.sg_private_level_2.id}"
  description              = "Security Group"
  security_group_id        = "${aws_security_group.sg_private_level_2.id}"
}

resource "aws_security_group_rule" "private_level_2_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_private_level_2.id}"
}

########### Private level 1
resource "aws_security_group" "sg_private_level_1" {
  name                   = "${format("%s_sg_private_level_1_%s", var.project, var.env)}"
  description            = "${var.project} Private Level 1"
  vpc_id                 = "${data.terraform_remote_state.vpc.vpc_id}"
  revoke_rules_on_delete = true

  tags {
    Name = "${format("%s_sg_private_level_1_%s", var.project, var.env)}"
    env  = "${var.env}"
    Type = "SecurityGroup"
  }
}

resource "aws_security_group_rule" "private_level_1_ingress" {
  type              = "ingress"
  count             = "${length(local.private_level_1_permitted_cidrs)}"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${lookup(local.private_level_1_permitted_cidrs[count.index], "cidr")}"]
  description       = "${lookup(local.private_level_1_permitted_cidrs[count.index], "description")}"
  security_group_id = "${aws_security_group.sg_private_level_1.id}"
}

resource "aws_security_group_rule" "private_level_1_ingress_security_group" {
  type                     = "ingress"
  count                    = 1
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Security Group"
  source_security_group_id = "${aws_security_group.sg_private_level_1.id}"
  security_group_id        = "${aws_security_group.sg_private_level_1.id}"
}

resource "aws_security_group_rule" "private_level_1_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_private_level_1.id}"
}

resource "aws_security_group" "sg_public" {
  name                   = "${format("%s_sg_public_%s", var.project, var.env)}"
  description            = "${var.project} Public"
  vpc_id                 = "${data.terraform_remote_state.vpc.vpc_id}"
  revoke_rules_on_delete = true

  tags {
    Name = "${format("%s_sg_public_%s", var.project, var.env)}"
    env  = "${var.env}"
    Type = "SecurityGroup"
  }
}

resource "aws_security_group_rule" "public_ingress" {
  type              = "ingress"
  count             = 1
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "${aws_security_group.sg_public.name}"
  security_group_id = "${aws_security_group.sg_public.id}"
}


resource "aws_security_group_rule" "public_egress" {
  type              = "egress"
  count             = 1
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "${aws_security_group.sg_public.name}"
  security_group_id = "${aws_security_group.sg_public.id}"
}