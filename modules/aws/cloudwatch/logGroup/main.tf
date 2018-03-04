terraform {
  required_version  = "> 0.9.8"
}

resource "aws_cloudwatch_log_group" "main" {
  name = "${var.name}"
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

resource "aws_cloudwatch_log_stream" "main" {
  name           = "${var.stream_name}"
  log_group_name = "${aws_cloudwatch_log_group.main.name}"
}