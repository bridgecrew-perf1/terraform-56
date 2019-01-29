output "cloudtrail_id" {
  value = "${aws_cloudtrail.main.id}"
}

output "cloudtrail_home_region" {
  value = "${aws_cloudtrail.main.home_region}"
}

output "cloudtrail_arn" {
  value = "${aws_cloudtrail.main.arn}"
}

output "log_group" {
  value = "${aws_cloudwatch_log_group.main.arn}"
}

output "cloudwatch_iam_role_arn" {
  value = "${aws_iam_role.cloudwatch.arn}"
}

output "kms_key_id" {
  value = "${aws_kms_key.main.id}"
}

output "kms_key_arn" {
  value = "${aws_kms_key.main.arn}"
}

output "cloudwatch_log_group" {
  value = "${aws_kms_key.main.id}"
}


output "cloudwatch_log_group_id" {
  value = "${aws_cloudwatch_log_group.main.id}"
}

output "cloudwatch_log_group_arn" {
  value = "${aws_cloudwatch_log_group.main.arn}"
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.main.arn}"
}

output "s3_bucket_id" {
  value = "${aws_s3_bucket.main.id}"
}

output "s3_bucket_bucket" {
  value = "${aws_s3_bucket.main.bucket}"
}

output "s3_bucket_replication_configuration" {
  value = "${aws_s3_bucket.main.replication_configuration}"
}
