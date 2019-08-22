provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "ec2" {
    ami                         = "${data.aws_ami.ubuntu.id}"
    instance_type               = "${var.instance_type}"
    disable_api_termination     = false
    key_name                    = "${var.key_name}"
    monitoring                  = true
    vpc_security_group_ids      = ["${data.terraform_remote_state.security_group.sg_private_level_1_id}"]
    subnet_id                   = "${data.terraform_remote_state.vpc.subnet_public_igw_ids[0]}"
    associate_public_ip_address = true
    iam_instance_profile        = "${aws_iam_instance_profile.ec2_instance_profile.name}"

    user_data = "${data.template_file.bootstrap.rendered}"

    tags = {
        env       = "${var.env}"
        env_infra = "${var.env_infra}"
        Name      = "${format("%s_%s_%s", var.project, var.desc, var.env)}"
        Type      = "EC2"
    }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2018.03.0.*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "template_file" "bootstrap" {
  template = "${file("${path.module}/files/ec2_bootstrap.sh")}"

  vars {
    ssh_bucket      = "${var.ssh_bucket}"
    ssh_key         = "${var.ssh_key}"
    git_repository  = "${var.git_repository}"
    git_branch      = "${var.git_branch}"
    desc            = "${var.desc}"
    region          = "${var.region}"
    env             = "${var.env}"
    env_infra       = "${var.env_infra}"
  }
}