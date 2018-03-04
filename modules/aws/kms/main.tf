terraform {
  required_version  = "> 0.11.2"
}

resource "aws_kms_key" "main" {
  description                 = "${var.description}"
  policy                      = "${var.policy}"
  is_enabled                  = "${var.is_enabled}"
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}
}

resource "aws_kms_alias" "main" {
  name          = "${var.key_alias}"
  target_key_id = "${aws_kms_key.main.key_id}"
}