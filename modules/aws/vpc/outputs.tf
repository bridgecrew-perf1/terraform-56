output "vpc_id" {
  value = "${aws_vpc.mod.id}"
}

output "subnet_a_id" {
  value = "${aws_subnet.public.0.id}"
}

output "subnet_b_id" {
  value = "${aws_subnet.public.1.id}"
}

output "subnet_c_id" {
  value = "${aws_subnet.public.2.id}"
}

output "subnet_d_id" {
  value = "${aws_subnet.private.0.id}"
}

output "subnet_e_id" {
  value = "${aws_subnet.private.1.id}"
}

output "subnet_f_id" {
  value = "${aws_subnet.private.2.id}"
}