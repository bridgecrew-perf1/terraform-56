/*

Cloudtrail s3 bucket policy

*/

data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "AWSCloudtrailPut"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::cloudtrail-121975435217-eu-west-1/*"]
  }
  statement {
    sid = "AWSCloudtrailGetAcl"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::cloudtrail-121975435217-eu-west-1"]
  }
}

/*

Cloudtrail kms key policy

*/

data "aws_iam_policy_document" "kms" {
  statement {
    sid = "EnableIamUserPermissions"
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::${var.account}:root"]
      type = "AWS"
    }
    actions = ["kms:*"]
    resources = ["*"]
  }
  statement {
    sid = "AllowCloudTrailEncryptLogs"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = ["kms:GenerateDataKey*"]
    resources = ["*"]
    condition {
      test = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values = ["arn:aws:cloudtrail:*:${var.account}:trail/*"]
    }
  }
  statement {
    sid = "AllowCloudTrailDescribeKey"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["kms:DescribeKey"]
    resources = ["*"]
  }
  statement {
    sid = "AllowCloudwatchLogs"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"]
    resources = ["*"]
  }
  statement {
    sid = "AllowPrincipalsDecryptLogFiles"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test = "StringEquals"
      values = ["${var.account}"]
      variable = "kms:CallerAccount"
    }
    condition {
      test = "StringLike"
      values = ["arn:aws:cloudtrail:*:${var.account}:trail/*"]
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
    }
  }
  statement {
    sid = "EnableCrossAccountLogDecryption"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    actions = [
      "kms:Decrypt",
      "kms:ReEncryptFrom"
    ]
    resources = ["*"]
    condition {
      test = "StringEquals"
      values = ["${var.account}"]
      variable = "kms:CallerAccount"
    }
    condition {
      test = "StringLike"
      values = ["arn:aws:cloudtrail:*:${var.account}:trail/*"]
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
    }
  }
}

/*

Cloudtrail s3 bucket IAM policy for replication

*/
data "aws_iam_policy_document" "assume_replication" {
  statement {
    sid = "sts"
    effect = "Allow"
    principals {
      identifiers = ["s3.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "replication" {
  statement {
    sid = "GetRepConfiguration"
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = ["${aws_s3_bucket.main.arn}/*"]
  }
  statement {
    sid = "GetObjectVersion"
    effect = "Allow"
    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl"
    ]
    resources = ["${aws_s3_bucket.main.arn}/*"]
  }
  statement {
    sid = "ReplicateDestiantion"
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete"
    ]
    resources = ["${var.s3_destination_bucket_arn}/*"]
  }
}

/*

Cloudtrail IAM policy for log Group

*/
data "aws_iam_policy_document" "assume_cloudwatch" {
  statement {
    sid = "sts"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    sid = "AWSCloudTrailCreateLogStream"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.main.arn}*"]
  }
}