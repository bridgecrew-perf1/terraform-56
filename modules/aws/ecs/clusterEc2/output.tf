output "ecs_id" {
  value = "${aws_ecs_cluster.main.id}"
}

output "ecs_arn" {
  value = "${aws_ecs_cluster.main.arn}"
}

output "name" {
  value = "${aws_key_pair.main.key_name}"
}

output "fingerprint" {
  value = "${aws_key_pair.main.fingerprint}"
}

output "id" {
  value = "${aws_autoscaling_group.main.id}"
}

output "name" {
  value = "${aws_autoscaling_group.main.name}"
}

output "arn" {
  value = "${aws_autoscaling_group.main.arn}"
}

