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

data "template_file" "ec2_access_policy" {
  template = "${file("${path.module}/files/access_policy.json")}"

  vars {
    project_bucket = "${var.project_bucket}"
    ssh_bucket     = "${var.ssh_bucket}"
  }
}

resource "aws_iam_policy" "ec2_access_policy" {
  name        = "${format("%s_%s_ec2-policy_%s", var.project, var.desc, var.env)}"
  path        = "/"
  description = "${format("%s %s ec2 policy %s", var.project, var.desc, var.env)}"

  policy = "${data.template_file.ec2_access_policy.rendered}"
}

resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.project}_ec2JobInstanceRole_${var.env}"
  description        = "${var.project}_ec2JobInstanceRole_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "ec2_instance_role" {
  role       = "${aws_iam_role.ec2_instance_role.name}"
  policy_arn = "${aws_iam_policy.ec2_access_policy.arn}"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project}_ec2JobInstanceProfile_${var.env}"
  role = "${aws_iam_role.ec2_instance_role.name}"
}


# AmazonSQSFullAccess
# AmazonS3FullAccess
# CloudWatchFullAccess
# CloudWatchLogsFullsAccess
# CloudWatchEventsFullAccess