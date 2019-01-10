resource "aws_s3_bucket" "main" {
  bucket = "${var.name}"
  acl    = "${var.acl}"
  logging {
    target_bucket = "${var.target_bucket}"
    target_prefix = "${var.target_prefix}"
  }
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://${var.fqdn}"]
    max_age_seconds = 300
  }
  website {
    index_document = "${var.index_document}"
    error_document = "${var.error_document}"
  }
  force_destroy = "${var.destroy}"
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}