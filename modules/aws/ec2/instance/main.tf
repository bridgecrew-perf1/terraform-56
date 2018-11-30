
terraform {
  required_version  = "> 0.11.7"
}

resource "aws_instance" "main" {
  ami                           = "${var.ami}"
  instance_type                 = "${var.instance_type}"
  iam_instance_profile          = "${var.iam_instance_profile}"
  availability_zone             = "${var.availability_zone}"
  ebs_optimized                 = "${var.ebs_optimized}"
  disable_api_termination       = "${var.disable_api_termination}"
  key_name                      = "${var.key_name}"
  monitoring                    = "${var.monitoring}"
  security_groups               = ["${var.security_groups}"]
  source_dest_check             = "${var.source_dest_check}"
  user_data                     = "${var.user_data}"
  root_block_device {
    volume_type                 = "${var.volume_type}"
    volume_size                 = "${var.volume_size}"
  }
  tags {
    Name                        = "${var.name}"
    Project                     = "${var.tag_project}"
    Environment                 = "${var.tag_env}"
    awsCostCenter               = "${var.tag_costcenter}"
    CreatedBy                   = "${var.tag_createdby}"
  }
}