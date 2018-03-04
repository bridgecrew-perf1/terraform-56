terraform {
  required_version  = "> 0.9.8"
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.name}"
  acl    = "${var.acl}"
  force_destroy = "${var.destroy}"
  tags {
    Name                       = "${var.name}.vpc.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}