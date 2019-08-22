provider "aws" {
  region = "${var.region}"
}

resource "aws_redshift_cluster" "main_redshift_cluster" {
    node_type           = "${var.cluster_node_type}"
    number_of_nodes     = "${var.cluster_number_of_nodes}"
    database_name       = "${var.cluster_database_name}"
    master_username     = "${var.cluster_master_username}"
    master_password     = "${var.cluster_master_password}"
    port                = "${var.cluster_port}"
    cluster_identifier  = "${format("%s-%s-%s", var.project, var.desc, var.env)}"
    vpc_security_group_ids = ["${data.terraform_remote_state.security_group.sg_public_id}"]

    # We're creating a subnet group in the module and passing in the name
    cluster_subnet_group_name    = "${aws_redshift_subnet_group.main_redshift_subnet_group.name}"
    cluster_parameter_group_name = "${aws_redshift_parameter_group.main_redshift_cluster.id}"

    publicly_accessible = "${var.publicly_accessible}"

    # Snapshots and backups
    skip_final_snapshot                 = "${var.skip_final_snapshot}"
    automated_snapshot_retention_period = "${var.automated_snapshot_retention_period }"
    preferred_maintenance_window        = "${var.preferred_maintenance_window}"

    # IAM Roles
    iam_roles = [
      "${aws_iam_role.redshift_role.arn}",
      "${aws_iam_role.redshift_glue_role.arn}"
    ]

    lifecycle {
        prevent_destroy = false
    }
}

resource "aws_redshift_parameter_group" "main_redshift_cluster" {
  #name   = "${var.desc}-${replace(var.cluster_parameter_group, ".", "-")}-custom-params"
  name   = "redshift-parameter-group-${var.env}"
  family = "${var.cluster_parameter_group}"

  parameter {
    name  = "wlm_json_configuration"
    value = "${var.wlm_json_configuration}"
  }
}

resource "aws_redshift_subnet_group" "main_redshift_subnet_group" {
  name        = "${format("%s-%s-%s-redshift-subnetgrp", var.project, var.desc, var.env)}"
  description = "Redshift subnet group of ${var.desc}"
  subnet_ids  = ["${data.terraform_remote_state.vpc.subnet_public_igw_ids[0]}"]

  tags {
    env       = "${var.env}"
    env_infra = "${var.env_infra}"
    Name      = "${format("%s_%s_%s", var.project, var.desc, var.env)}"
    Type      = "Redshift"
  }

}
