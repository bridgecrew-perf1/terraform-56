terraform {
  required_version  = "> 0.11.2"
}

resource "aws_iam_role" "main" {
  description                 = "${var.name} IAM ec2 Role"
  name                        = "${var.name}"
  path                        = "${var.iam_policy_path}"
  assume_role_policy          = "${var.assume_role_policy}"
  tags {

  }
}

resource "aws_iam_role_policy_attachment" "main" {
  role                      = "${aws_iam_role.main.name}"
  policy_arn                = "${var.policy_arn}"
}