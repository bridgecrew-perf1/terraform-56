terraform {
  required_version  = "> 0.9.8"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.name}"
}