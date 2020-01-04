terraform {
  required_version  = "> 0.11.2"
}

resource "aws_waf_ipset" "main" {
  name = "${var.name}"

  ip_set_descriptors {
    type  = "${var.type}"
    value = "${var.value_1}"
  }
  ip_set_descriptors {
    type  = "${var.type}"
    value = "${var.value_2}"
  }
}