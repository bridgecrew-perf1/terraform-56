terraform {
  required_version  = "> 0.9.8"
}

resource "aws_iam_instance_profile" "mod" {
  name                        = "${var.name}.ec2_role"
  path                        = "${var.iam_policy_path}" 
  role                        = "${aws_iam_role.mod.name}"
}

resource "aws_iam_role" "mod" {
  description                 = "${var.name} IAM ec2 Role"
  name                        = "${var.name}.iam_role"
  path                        = "${var.iam_policy_path}"
  assume_role_policy          = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "mod" {
    name                      = "${var.name}.iam_pol"
    description               = "${var.name} IAM policy"
    path                      = "${var.iam_policy_path}"
    policy                    = "${var.iam_policy_doc}"
}

resource "aws_iam_policy_attachment" "mod" {
    name                      = "test"
    roles                     = ["${aws_iam_role.mod.name}"]
    policy_arn                = "${aws_iam_policy.mod.arn}"
}
