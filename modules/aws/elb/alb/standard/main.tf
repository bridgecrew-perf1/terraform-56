
terraform {
  required_version  = "> 0.11.2"
}

resource "aws_lb" "main" {
  name                        = "${var.name}"
  internal                    = "${var.internal}"
  load_balancer_type          = "${var.load_balancer_type}"
  security_groups             = ["${var.security_groups}"]
  subnets                     = ["${var.subnets}"]
  enable_deletion_protection  = "${var.enable_deletion_protection}"
  access_logs {
    bucket                    = "${var.log_bucket}"
    prefix                    = "${var.bucket_prefix}"
  }
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}