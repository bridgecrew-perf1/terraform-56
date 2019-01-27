//output "cloudtrail_id" {
//  value = "${aws_cloudtrail.main.id}"
//}
//
//output "cloudtrail_home_region" {
//  value = "${aws_cloudtrail.main.home_region}"
//}
//
//output "cloudtrail_arn" {
//  value = "${aws_cloudtrail.main.arn}"
//}

output "log_group" {
  value = "${aws_cloudwatch_log_group.main.arn}"
}