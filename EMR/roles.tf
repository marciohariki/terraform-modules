data "aws_iam_policy_document" "emr_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "emr_service_role" {
  name               = "${var.project}_EMRServiceRole_${var.env}"
  description        = "${var.project}_EMRServiceRole_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.emr_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "emr_service_role" {
  role       = "${aws_iam_role.emr_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

#
# EMR IAM resources for EC2
#
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "template_file" "emr_access_policy" {
  template = "${file("${path.module}/files/access_policy.json")}"

  vars {
    project_bucket         = "${var.project_bucket}",
    project_archive_bucket = "${var.project_archive_bucket}"
  }
}

resource "aws_iam_policy" "emr_access_policy" {
  name        = "${format("%s_%s_emrcluster-policy_%s", var.project, var.desc, var.env)}"
  path        = "/"
  description = "${format("%s %s emrcluster policy %s", var.project, var.desc, var.env)}"

  policy = "${data.template_file.emr_access_policy.rendered}"
}

locals {
  policies_to_use = [
    "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role",
    "${aws_iam_policy.emr_access_policy.arn}"
  ]
}

resource "aws_iam_role" "emr_ec2_instance_role" {
  name               = "${var.project}_EMRJobInstanceRole_${var.env}"
  description        = "${var.project}_EMRJobInstanceRole_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

# Attach all needed roles
resource "aws_iam_role_policy_attachment" "emr_ec2_instance_role" {
  count      = 2 # "${length(local.policies_to_use)}" -> cannot ask for length of computed value. Terraform issue
  role       = "${aws_iam_role.emr_ec2_instance_role.name}"
  policy_arn = "${local.policies_to_use[count.index]}"
}

resource "aws_iam_instance_profile" "emr_ec2_instance_profile" {
  name = "${var.project}_EMRJobInstanceProfile_${var.env}"
  role = "${aws_iam_role.emr_ec2_instance_role.name}"
}

#
## Auto scaling
#

data "aws_iam_policy_document" "emr_auto_scaling_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = [
        "application-autoscaling.amazonaws.com",
        "elasticmapreduce.amazonaws.com"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "emr_auto_scaling_role" {
  name               = "${var.project}_EMRAutoScalingRole_${var.env}"
  description        = "${var.project}_EMRAutoScalingRole_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.emr_auto_scaling_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "emr_auto_scaling_role" {
  role       = "${aws_iam_role.emr_auto_scaling_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforAutoScalingRole"
}
