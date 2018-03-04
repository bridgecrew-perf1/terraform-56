terraform {
  required_version  = "> 0.11.2"
}

resource "aws_cloudtrail" "main" {
  name                          = "${var.name}"
  s3_bucket_name                = "${var.bucket_name}"
  s3_key_prefix                 = "${var.s3_key_prefix}"
  enable_logging                = "${var.enable_logging}"
  include_global_service_events = "${var.include_global_service_events}"
  is_multi_region_trail         = "${var.is_multi_region_trail}"
  enable_log_file_validation    = "${var.enable_log_file_validation}"
  kms_key_id                    = "${var.kms_key_id}"
  event_selector {
    read_write_type = "${var.read_write_type}"
    include_management_events = "${var.include_management_events}"
  #   data_resource {
  #     type = "AWS::S3::Object"
  #     values = [
  #        "arn:aws:s3:::tf-bucket/foobar",
  #      ]
  #   }
  # }
  }
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}