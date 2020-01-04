terraform {
  required_version = "> 0.11.12"
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "main" {
  name      = "${var.name}"
  on_create = "${var.on_create}"
  on_start  = "${var.on_start}"
}