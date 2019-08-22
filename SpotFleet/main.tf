provider "aws" {
  region = "${var.region}"
}

resource "aws_spot_fleet_request" "cheap_compute" {
  iam_fleet_role      = "${aws_iam_role.fleet.arn}"
  target_capacity     = "${var.target_capacity}"
  valid_until         = "${var.valid_until}"

  launch_specification {
    instance_type             = "${var.instance_type}"
    ami                       = "${var.ami_id}"
    iam_instance_profile_arn  = "${data.terraform_remote_state.ec2.aws_ec2_instance_profile_arn}"
    availability_zone         = "${data.aws_availability_zones.available.names[0]}"
    subnet_id                 = "${data.terraform_remote_state.vpc.subnet_public_igw_ids[0]}"
    key_name                  = "${var.key_name}"
    vpc_security_group_ids    = ["${data.terraform_remote_state.security_group.sg_private_level_1_id}"]

    tags = {
        env       = "${var.env}"
        env_infra = "${var.env_infra}"
        Name      = "${format("SpotFleet_%s_%s", var.project, var.env)}"
        Type      = "SpotFleet"
    }
  }

  launch_specification {
    instance_type             = "${var.instance_type}"
    ami                       = "${var.ami_id}"
    iam_instance_profile_arn  = "${data.terraform_remote_state.ec2.aws_ec2_instance_profile_arn}"
    availability_zone         = "${data.aws_availability_zones.available.names[1]}"
    subnet_id                 = "${data.terraform_remote_state.vpc.subnet_public_igw_ids[1]}"
    key_name                  = "${var.key_name}"
    vpc_security_group_ids    = ["${data.terraform_remote_state.security_group.sg_private_level_1_id}"]

    tags = {
        env       = "${var.env}"
        env_infra = "${var.env_infra}"
        Name      = "${format("SpotFleet_%s_%s", var.project, var.env)}"
        Type      = "SpotFleet"
    }
  }

  launch_specification {
    instance_type             = "${var.instance_type}"
    ami                       = "${var.ami_id}"
    iam_instance_profile_arn  = "${data.terraform_remote_state.ec2.aws_ec2_instance_profile_arn}"
    availability_zone         = "${data.aws_availability_zones.available.names[2]}"
    subnet_id                 = "${data.terraform_remote_state.vpc.subnet_public_igw_ids[2]}"
    key_name                  = "${var.key_name}"
    vpc_security_group_ids    = ["${data.terraform_remote_state.security_group.sg_private_level_1_id}"]

    tags = {
        env       = "${var.env}"
        env_infra = "${var.env_infra}"
        Name      = "${format("SpotFleet_%s_%s", var.project, var.env)}"
        Type      = "SpotFleet"
    }
  }
}