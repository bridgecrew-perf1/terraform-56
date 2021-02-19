terraform {
  required_version  = "> 0.11.2"
}

resource "aws_efs_file_system" "main" {
  performance_mode = "${var.performance_mode}"
  encrypted        = "${var.encrypted}"
  kms_key_id       = "${var.kms_key_id}"
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}