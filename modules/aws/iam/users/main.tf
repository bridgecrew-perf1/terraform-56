
terraform {
//  required_version  = "> 0.11.10"
}

resource "aws_iam_user" "main" {
  count = "${length(var.users) > 0 ? length(var.users) : 0}"
  name = "${element(var.users, count.index)}"
  force_destroy = "${var.force_destroy}"
  path = "${var.path}"
  tags = {
    Name                       = "${element(var.users, count.index)}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

