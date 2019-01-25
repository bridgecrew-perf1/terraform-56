data "aws_cloudtrail_service_account" "main" {
  region = "${var.region}"
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "AWSCloudtrailPut"
    effect = "Allow"
    principals {
      identifiers = ["${data.aws_cloudtrail_service_account.main.arn}"]
      type = "AWS"
    }
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
  }
  statement {
    sid = "AWSCloudtrailGetAcl"
    effect = "Allow"
    principals {
      identifiers = ["${data.aws_cloudtrail_service_account.main.arn}"]
      type = "AWS"
    }
    actions = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.main.arn}"]
  }
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid = "EnableIamUserPermissions"
    effect = "Allow"
    principals {
      identifiers = [
        "arn:aws:iam::${var.account}:root",
        "arn:aws:iam::${var.account}:user/username"
      ]
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
      identifiers = ["Service"]
      type = "cloudtrail.amazonaws.com"
    }
    actions = ["kms:DescribeKey"]
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
    sid = "AllowAliasCreation"
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    actions = ["kms:CreateAlias"]
    resources = ["*"]
    condition {
      test = "StringEquals"
      values = ["ec2.${var.region}.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test = "StringEquals"
      values = ["${var.account}"]
      variable = "kms:CallerAccount"
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

data "aws_iam_policy_document" "assume_replication" {
  statement {
    sid = "sts"
    effect = "Allow"
    principals {
      identifiers = ["s3.amazonaws.com"]
      type = "Service"
    }
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
    resources = ["${var.s3_destinatino_bucket_arn}/*"]
  }
}

