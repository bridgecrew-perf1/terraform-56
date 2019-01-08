
terraform {
//  required_version  = "> 0.11.10"
}

resource "aws_iam_user" "main" {
  name = "${var.name}"
  force_destroy = "${var.force_destroy}"
  path = "${var.path}"
  tags = {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

