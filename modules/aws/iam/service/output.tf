output "iam_role_arn" {
  value = "${aws_iam_instance_profile.main.arn}"
}

output "iam_role_unique_id" {
  value = "${aws_iam_instance_profile.main.unique_id}"
}

output "iam_role_name" {
  value = "${aws_iam_instance_profile.main.name}"
}
