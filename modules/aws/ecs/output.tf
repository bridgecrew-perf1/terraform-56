output "ecs_id" {
  value = "${aws_ecs_cluster.mod.id}"
}

output "ecs_arn" {
  value = "${aws_ecs_cluster.mod.arn}"
}