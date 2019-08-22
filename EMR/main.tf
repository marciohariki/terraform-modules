provider "aws" {
  region = "${var.region}"
}

resource "aws_emr_cluster" "emr_cluster" {
  name          = "${format("%s_%s_%s", var.project, var.desc, var.env)}"
  release_label = "${var.emr_release}"
  applications  = "${var.emr_services}"

  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true

  depends_on = [
    "aws_s3_bucket_object.emr_bootstrap_script"
  ]

  configurations = "${data.template_file.spark_defaults.rendered}"

  ec2_attributes {
    key_name                          = "${var.key_name}"
    subnet_id                         = "${data.terraform_remote_state.vpc.subnet_public_igw_ids[0]}"
    emr_managed_master_security_group = "${data.terraform_remote_state.security_group.sg_private_level_1_id}"
    emr_managed_slave_security_group  = "${data.terraform_remote_state.security_group.sg_private_level_2_id}"
    instance_profile                  = "${aws_iam_instance_profile.emr_ec2_instance_profile.arn}"
  }

  log_uri              = "s3://${var.logs_bucket}/${var.logs_path}/${var.env}"
  ebs_root_volume_size = "${var.ebs_root_volume_size}"
  
  instance_group {
    instance_role  = "MASTER"
    instance_count = "1"
    instance_type  = "${var.master_instance_type}"
    name           = "Master"
    ebs_config     = {
        size                 = "100"
        type                 = "gp2"
        volumes_per_instance = 1
      }
  }

  instance_group {
    instance_role  = "CORE"
    instance_count = "${var.core_instance_count}"
    instance_type  = "${var.core_instance_type}"
    name           = "Core"
    bid_price      = "${var.core_bid_price}"
    ebs_config     = {
        size                 = "40"
        type                 = "gp2"
        volumes_per_instance = 1
      }
  }

  # Comentado porque não estamos usando tasks neste momento, mas está tudo pronto para usar.
  # instance_group {
  #   instance_role  = "TASK"
  #   instance_count = "${var.task_instance_count}"
  #   instance_type  = "${var.task_instance_type}"
  #   name           = "Task"
  #   bid_price      = "${var.task_bid_price}"
  #   ebs_config     = {
  #       size                 = "20"
  #       type                 = "gp2"
  #       volumes_per_instance = 1
  #     }
  #   autoscaling_policy = "${data.template_file.autoscaling_policy.rendered}"
  # }

  autoscaling_role = "${aws_iam_role.emr_auto_scaling_role.arn}"

  tags {
    env       = "${var.env}"
    env_infra = "${var.env_infra}"
    Name      = "${format("%s_%s_%s", var.project, var.desc, var.env)}"
    Type      = "EMR"
  }

  bootstrap_action {
    path = "s3://${var.bootstrap_bucket}/${var.bootstrap_key}"
    name = "bootstrap"
  }

  service_role = "${aws_iam_role.emr_service_role.arn}"
}

resource "aws_s3_bucket_object" "emr_bootstrap_script" {
  bucket  = "${var.bootstrap_bucket}"
  key     = "${var.bootstrap_key}"
  content = "${data.template_file.bootstrap.rendered}"
}

data "template_file" "bootstrap" {
  template = "${file("${path.module}/files/emr_bootstrap.sh")}"

  vars {
    env             = "${var.env}"
    region          = "${var.region}"
    git_repository  = "${var.git_repository}"
    git_branch      = "${var.git_branch}"
    ssh_bucket      = "${var.ssh_bucket}"
    ssh_key         = "${var.ssh_key}"
    configpy_bucket = "${var.configpy_bucket}"
    configpy_key    = "${var.configpy_key}"
    desc            = "${var.desc}"
    deploy          = "${var.deploy}"
    env_infra       = "${var.env_infra}"
    account_number  = "${var.account_number}"
  }
}

data "template_file" "spark_defaults" {
  template = "${file("${path.module}/files/emr_config.json")}"

  vars {
    executor_instances      = "${var.spark_defaults_executor_instances}"
    executor_memoryOverhead = "${var.spark_defaults_executor_memoryOverhead}"
    executor_memory         = "${var.spark_defaults_executor_memory}"
    driver_memoryOverhead   = "${var.spark_defaults_driver_memoryOverhead}"
    driver_memory           = "${var.spark_defaults_driver_memory}"
    executor_cores          = "${var.spark_defaults_executor_cores}"
    driver_cores            = "${var.spark_defaults_driver_cores}"
    default_parallelism     = "${var.spark_defaults_default_parallelism}"
    sql_shuffle_partitions  = "${var.spark_defaults_sql_shuffle_partitions}"
  }
}

data "template_file" "autoscaling_policy" {
  template = "${file("${path.module}/files/autoscaling_policy.json")}"

  vars {
    min_auto_scaling_task_nodes = "${var.min_auto_scaling_task_nodes}"
    max_auto_scaling_task_nodes = "${var.max_auto_scaling_task_nodes}"
  }
}
