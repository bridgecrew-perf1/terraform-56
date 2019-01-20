
resource "aws_iam_group" "main" {
  name = "${var.name}"
  path = "${var.path}"
}

resource "aws_iam_group_membership" "main" {
  name = "${var.name}-group-membership"
  users = ["${var.group_users}"]
  group = "${aws_iam_group.main.id}"
}

resource "aws_iam_group_policy" "main" {
  count = "${length(var.users) > 0 ? : 0}"
  name  = "${var.name}_group_policy"
  group = "${aws_iam_group.main.id}"
  policy = "${var.policy}"
}

resource "aws_iam_group_policy_attachment" "main" {
  count = "${length(var.users) > 0 ? length(var.users) : 0}"
  group      = "${aws_iam_group.main.id}"
  policy_arn = "${var.policy_arn}"
}