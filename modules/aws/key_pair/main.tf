terraform {
  required_version  = "0.9.8"
}

resource "aws_key_pair" "mod" {
  key_name                    = "${var.key_name}"
  public_key                  = "${var.key_pair}"
}