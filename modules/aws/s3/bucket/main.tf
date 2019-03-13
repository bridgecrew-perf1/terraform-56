terraform {
  required_version  = "> 0.11.10"
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.name}"
  acl    = "${var.acl}"
  policy = "${var.policy}"
  force_destroy = "${var.destroy}"
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    ModifiedBy                 = "${var.tag_modifiedby}"
  }
}