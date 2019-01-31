terraform {
  required_version  = "> 0.9.8"
}

resource "aws_iam_role" "replication" {
  description                 = "${var.name} replication Role"
  name                        = "${var.name}_replication_role"
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
  name                      = "${var.name}_replication_policy"
  description               = "${var.name} replication policy"
  path                      = "${var.iam_policy_path}"
  policy                    = "${data.aws_iam_policy_document.replication.json}"
}

resource "aws_iam_policy_attachment" "replication" {
  name                      = "${var.name}_cloudtrail_replication_attachment"
  roles                     = ["${aws_iam_role.replication.name}"]
  policy_arn                = "${aws_iam_policy.replication.arn}"
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
      status = "${var.replication_configuration_status}"
      destination {
        account_id = "${var.s3_destination_account_id}"
        bucket = "${aws_s3_bucket.main.arn}"
        replica_kms_key_id = "${aws_kms_key.main.id}"
        storage_class = "${var.storage_class}"
      }
      source_selection_criteria {
        sse_kms_encrypted_objects {
          enabled = "${var.source_selection_criteria_sse_status}"
        }
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
  force_destroy = "${var.force_destroy}"
  tags {
    Name = "${var.name}"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
}
