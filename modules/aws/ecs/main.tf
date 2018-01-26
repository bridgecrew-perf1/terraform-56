resource "aws_ecs_cluster" "mod" {
  name = "${var.name}"
}