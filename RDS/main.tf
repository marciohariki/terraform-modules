provider "aws" {
  region = "${var.region}"
}

locals {
  port = "${var.default_ports[var.engine]}"
}

resource "aws_db_subnet_group" "rds" {
  name        = "${var.projectlower}-${var.env}${var.tag}-rds"
  description = "Our main group of subnets"
  subnet_ids  = ["${data.terraform_remote_state.vpc.subnet_public_igw_ids}"]
}

resource "aws_db_parameter_group" "rds" {
  count       = "${length(var.rds_custom_parameter_group_name) == 0 ? 1 : 0}"
  name_prefix = "${var.engine}-${var.projectlower}-${var.env}${var.tag}-"
  family      = "${var.default_parameter_group_family}"
  description = "RDS ${var.projectlower} ${var.env} parameter group for ${var.engine}"
  parameter   = "${var.default_db_parameters[var.engine]}"
}

resource "aws_db_instance" "rds" {
  identifier                = "${var.projectlower}-rds-${var.env}${var.tag}${var.number}"
  allocated_storage         = "${var.storage}"
  engine                    = "${var.engine}"
  engine_version            = "${var.engine_version}"
  instance_class            = "${var.size}"
  storage_type              = "${var.storage_type}"
  username                  = "${var.rds_user}"
  password                  = "${var.rds_password}"
  vpc_security_group_ids    = ["${data.terraform_remote_state.security_group.sg_public_id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.rds.id}"
  parameter_group_name      = "${length(var.rds_custom_parameter_group_name) > 0 ? var.rds_custom_parameter_group_name : aws_db_parameter_group.rds.name}"
  multi_az                  = "${var.multi_az}"
  replicate_source_db       = "${var.replicate_source_db}"
  backup_retention_period   = "${var.backup_retention_period}"
  storage_encrypted         = "${var.storage_encrypted}"
  apply_immediately         = "${var.apply_immediately}"
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  final_snapshot_identifier = "${var.project}-${var.env}${var.tag}-rds${var.number}-final-${md5(timestamp())}"
  availability_zone         = "${var.availability_zone}"
  snapshot_identifier       = "${var.snapshot_identifier}"
  publicly_accessible       = "${var.publicly_accessible}"
  name                      = "${var.db_name}"

  tags {
    Name        = "${var.project}-${var.env}${var.tag}-rds${var.number}"
    Environment = "${var.env}"
    Project     = "${var.project}"
    Type        = "RDS"
  }

  lifecycle {
    ignore_changes = ["final_snapshot_identifier"]
  }
}
