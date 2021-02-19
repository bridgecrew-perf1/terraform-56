
// s3 bucket
output "s3_id" {
  value = "${aws_s3_bucket.main.id}"
}

output "s3_arn" {
  value = "${aws_s3_bucket.main.arn}"
}

output "s3_region" {
  value = "${aws_s3_bucket.main.region}"
}

// kms Key

output "kms_arn" {
  value = "${aws_kms_key.main.arn}"
}

output "kms_id" {
  value = "${aws_kms_key.main.key_id}"
}
