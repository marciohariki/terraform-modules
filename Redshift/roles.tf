data "aws_iam_policy_document" "redshift_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "redshift_role" {
  name               = "${var.project}_RedshiftServiceRole_${var.env}"
  description        = "${var.project}_RedshiftServiceRole_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.redshift_role.json}"
}


data "aws_iam_policy_document" "redshift_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "template_file" "redshift_access_policy" {
  template = "${file("${path.module}/files/redshift_policy.json")}"

  vars {
    project_bucket = "${var.project_bucket}"
  }
}

resource "aws_iam_policy" "redshift_access_policy" {
  name        = "${format("%s_%s_redshift-cluster-policy_%s", var.project, var.desc, var.env)}"
  path        = "/"
  description = "${format("%s %s  redshift cluster policy %s", var.project, var.desc, var.env)}"

  policy = "${data.template_file.redshift_access_policy.rendered}"
}

locals {
  policies_to_use = [
    "${aws_iam_policy.redshift_access_policy.arn}"
  ]
}

resource "aws_iam_role" "redshift_instance_role" {
  name               = "${var.project}_RedshiftJobInstanceRole_${var.env}"
  description        = "${var.project}_RedshiftJobInstanceRole_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.redshift_assume_role.json}"
}

# Attach all needed roles
resource "aws_iam_role_policy_attachment" "redshift_instance_role" {
  count      = 1 # "${length(local.policies_to_use)}" -> cannot ask for length of computed value. Terraform issue
  role       = "${aws_iam_role.redshift_instance_role.name}"
  policy_arn = "${local.policies_to_use[count.index]}"
}

resource "aws_iam_instance_profile" "redshift_instance_profile" {
  name = "${var.project}_RedshiftJobInstanceProfile_${var.env}"
  role = "${aws_iam_role.redshift_instance_role.name}"
}

# Redshift Glue
locals {
  policies_to_use_redshift_glue = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
  ]
}

resource "aws_iam_role" "redshift_glue_role" {
  name               = "${var.project}_RedshiftGlueRole_${var.env}"
  description        = "${var.project}_RedshiftGlueRole_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.redshift_role.json}"
}

resource "aws_iam_role_policy_attachment" "redshift_glue_role" {
  count      = 2 # "${length(local.policies_to_use)}" -> cannot ask for length of computed value. Terraform issue
  role       = "${aws_iam_role.redshift_glue_role.name}"
  policy_arn = "${local.policies_to_use_redshift_glue[count.index]}"
}

resource "aws_iam_instance_profile" "redshift_glue_profile" {
  name = "${var.project}_RedshiftGlueProfile_${var.env}"
  role = "${aws_iam_role.redshift_glue_role.name}"
}
