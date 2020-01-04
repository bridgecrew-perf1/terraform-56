
terraform {
  required_version  = "> 0.11.12"
}

resource "aws_iam_user" "main" {
  name = "${var.name}"
  force_destroy = "${var.force_destroy}"
  path = "${var.path}"
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}

resource "aws_iam_policy" "main" {
  name = "${var.name}-policy"
  policy = "${var.policy}"
}

resource "aws_iam_policy_attachment" "main" {
  name = "${var.name}"
  users = ["${aws_iam_user.main.name}"]
  policy_arn = "${aws_iam_policy.main.arn}"
}
