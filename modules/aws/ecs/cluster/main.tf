terraform {
  required_version  = "> 0.11.8"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.name}"
  tags = {
    Name = "${var.name}"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
}

