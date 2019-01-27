terraform {
  required_version = "> 0.11.7"
}

resource "aws_iam_role" "replication" {
  description                 = "${var.name} cloudtrail replication Role"
  name                        = "${var.name}_cloudtrail_replication_role"
  path                        = "${var.iam_policy_path}"
  assume_role_policy          = "${data.aws_iam_policy_document.assume_replication.json}"
  tags {
    Name = "${var.name}_replication_role"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
}

resource "aws_iam_policy" "replication" {
  name                      = "${var.name}_cloudtrail_replication_policy"
  description               = "${var.name} cloudtrail replication policy"
  path                      = "${var.iam_policy_path}"
  policy                    = "${data.aws_iam_policy_document.replication.json}"
}

resource "aws_iam_policy_attachment" "replication" {
  name                      = "${var.name}_cloudtrail_replication_attachment"
  roles                     = ["${aws_iam_role.replication.name}"]
  policy_arn                = "${aws_iam_policy.replication.arn}"
}

resource "aws_iam_role" "cloudwatch" {
  description                 = "${var.name} cloudtrail cloudwatch Role"
  name                        = "${var.name}_cloudtrail_cloudwatch_role"
  path                        = "${var.iam_policy_path}"
  assume_role_policy          = "${data.aws_iam_policy_document.assume_cloudwatch.json}"
  tags {
    Name = "${var.name}_cloudwatch_role"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
}

resource "aws_iam_policy" "cloudwatch" {
  name                      = "${var.name}_cloudtrail_cloudwatch_policy"
  description               = "${var.name} cloudtrail replication policy"
  path                      = "${var.iam_policy_path}"
  policy                    = "${data.aws_iam_policy_document.cloudwatch.json}"
}

resource "aws_iam_policy_attachment" "cloudwatch" {
  name                      = "${var.name}_cloudtrail_cloudwatch_attachment"
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
  tags {
    Name = "${var.name}"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.name}"
  retention_in_days = "${var.lg_retention_in_days}"
  kms_key_id = "${aws_kms_key.main.arn}"
  tags = {
    Name = "${var.name}"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
//  depends_on = ["aws_kms_key.main", "aws_iam_policy.cloudwatch"]
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
  replication_configuration {
    role = "${aws_iam_role.replication.arn}"
    rules {
      id = "${var.name}-replication"
      prefix = "${var.name}/${var.s3_key_prefix}replica"
      status = "${var.replication_configuration_status}"
      destination {
        account_id = "${var.s3_destination_account_id}"
        bucket = "${var.s3_destination_bucket_arn}"
        storage_class = "${var.storage_class}"
      }
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
//  object_lock_configuration {
//    object_lock_enabled = "${var.object_lock_configuration_enabled}"
//    rule = {
//      default_retention = {
//        mode = "${var.object_lock_configuration_default_retention_mode}"
//        days = "${var.object_lock_configuration_default_retention_days}"
//      }
//    }
//  }

  force_destroy = "${var.force_destroy}"
  tags {
    Name = "${var.name}"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
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
      type = "AWS::Lambda::Function"
      values = ["${var.lambda_arns}"]
    }
    data_resource {
      type = "AWS::S3::Object"
      values = ["${var.s3_arns}"]
    }
  }
  tags {
    Name = "${var.name}"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
}