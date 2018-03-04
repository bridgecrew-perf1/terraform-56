output "dynamodb_arn" {
  value = "${aws_dynamodb_table.main.arn}"
}

output "dynamodb_id" {
  value = "${aws_dynamodb_table.main.id}"
}

output "dynamodb_stream_arn" {
  value = "${aws_dynamodb_table.main.arn}"
}

output "dynamodb_stream_label" {
  value = "${aws_dynamodb_table.main.stream_label}"
}