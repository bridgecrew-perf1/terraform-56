//Cloudtrail s3 bucket policy

data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "AWSCloudtrailPut"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
  }
  statement {
    sid = "AWSCloudtrailGetAcl"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type = "Service"
    }
    actions = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.main.arn}"]
  }
}

//Cloudtrail kms key policy

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



//Cloudtrail s3 bucket IAM policy for replication

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
    sid = "SourceGetRepConfiguration"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetReplicationConfiguration",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = [
      "${aws_s3_bucket.main.arn}",
      "${aws_s3_bucket.main.arn}/*"
    ]
  }
  statement {
    sid = "DestinationReplicationConfiguration"
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
      "s3:PutObject"
    ]
    resources = ["${var.s3_destination_bucket_arn}/*"]
    condition {
      test = "StringLikeIfExists"
      values = [
        "aws:kms"
      ]
      variable = "s3:x-amz-server-side-encryption"
    }
    condition {
      test = "StringLikeIfExists"
      values = ["${var.s3_destination_kms_key_id}"]
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
    }
  }
  statement {
    sid = "SourceDecrypt"
    effect = "Allow"
    actions = ["kms:Decrypt"]
    resources = ["${aws_kms_key.main.arn}/*"]
    condition {
      test = "StringLike"
      values = ["s3.${var.region}.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test = "StringLike"
      values = ["${aws_s3_bucket.main.arn}/*"]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
  }
  statement {
    sid = "DestinationEncrypt"
    effect = "Allow"
    actions = ["kms:Encrypt"]
    resources = ["${var.s3_destination_kms_key_id}"]
    condition {
      test = "StringLike"
      values = ["s3.${var.s3_destination_region}.amazonaws.com"]
      variable = "kms:ViaService"
    }
    condition {
      test = "StringLike"
      values = ["${var.s3_destination_bucket_arn}/*"]
      variable = "kms:EncryptionContext:aws:s3:arn"
    }
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
