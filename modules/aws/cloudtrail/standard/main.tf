terraform {
  required_version = "> 0.11.7"
}

resource "aws_iam_role" "cloudwatch" {
  description                 = "${var.name} cloudwatch Role"
  name                        = "${var.name}_cloudwatch_role"
  path                        = "${var.iam_policy_path}"
  assume_role_policy          = "${data.aws_iam_policy_document.assume_cloudwatch.json}"
  tags = "${merge(map(
    "Name", "${var.name}_cloudwatch_role",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}

resource "aws_iam_policy" "cloudwatch" {
  name                      = "${var.name}_cloudwatch_policy"
  description               = "${var.name} cloudwatch policy"
  path                      = "${var.iam_policy_path}"
  policy                    = "${data.aws_iam_policy_document.cloudwatch.json}"
}

resource "aws_iam_policy_attachment" "cloudwatch" {
  name                      = "${var.name}_cloudwatch_attachment"
  roles                     = ["${aws_iam_role.cloudwatch.name}"]
  policy_arn                = "${aws_iam_policy.cloudwatch.arn}"
}

resource "aws_kms_key" "main" {
  description = "${var.name} cloudtrail kms key"
  key_usage = "${var.key_usage}"
  policy = "${data.aws_iam_policy_document.kms.json}"
  is_enabled = "${var.kms_is_enabled}"
  enable_key_rotation = "${var.enable_key_rotation}"
  deletion_window_in_days = "${var.deletion_window_in_days}"
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.name}"
  retention_in_days = "${var.lg_retention_in_days}"
  kms_key_id = "${aws_kms_key.main.arn}"
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.name}"
  acl = "${var.acl}"
  versioning {
    enabled = "${var.versioning_enabled}"
  }
  region = "${var.region}"
  lifecycle_rule {
    enabled = "${var.lifecycle_rule_enabled}"
    id = "${var.name}"
    prefix = "${var.s3_key_prefix}"
    transition {
      days = "${var.transition_days}"
      storage_class = "${var.transition_storage_class}"
    }
    expiration {
      days = "${var.expirition_days}"
    }
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.main.id}"
        sse_algorithm = "aws:kms"
      }
    }
  }
  force_destroy = "${var.force_destroy}"
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}

resource "aws_s3_bucket_policy" "main" {
  bucket = "${aws_s3_bucket.main.id}"
  policy = "${data.aws_iam_policy_document.bucket.json}"
}

resource "aws_cloudtrail" "main" {
  name = "${var.name}"
  s3_bucket_name = "${aws_s3_bucket.main.id}"
  s3_key_prefix = "${var.s3_key_prefix}"
  cloud_watch_logs_role_arn = "${aws_iam_role.cloudwatch.arn}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.main.arn}"
  enable_logging = "${var.enable_logging}"
  include_global_service_events = "${var.include_global_service_events}"
  is_multi_region_trail = "${var.is_multi_region_trail}"
  enable_log_file_validation = "${var.enable_log_file_validation}"
  kms_key_id = "${aws_kms_key.main.arn}"
  event_selector {
    read_write_type = "${var.read_write_type}"
    include_management_events = "${var.include_management_events}"
    data_resource {
      type = "AWS::S3::Object"
      values = ["${aws_s3_bucket.main.arn}/"]
    }
  }
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}