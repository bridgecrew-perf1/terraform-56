output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_public_id" {
  value = ["${aws_subnet.public.*.id}"]
}

output "subnet_private_id" {
  value = ["${aws_subnet.private.*.id}"]
}

output "subnet_rds_id" {
  value = ["${aws_subnet.db.*.id}"]
}

output "subnet_ecs_id" {
  value = ["${aws_subnet.app.*.id}"]
}

output "subnet_rs_id" {
  value = ["${aws_subnet.rs.*.id}"]
}

output "route_table_private" {
  value = ["${aws_route_table.private.*.id}"]
}

output "route_table_rds" {
  value = ["${aws_route_table.db.*.id}"]
}

output "route_table_ecs" {
  value = ["${aws_route_table.app.*.id}"]
}

output "route_table_rs" {
  value = ["${aws_route_table.rs.*.id}"]
}
