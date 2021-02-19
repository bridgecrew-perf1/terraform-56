
provider "aws" {
  region     = "${var.region}"
  assume_role {
    role_arn = "${var.role_arn}"
  }
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

provider "aws" {
  alias = "current"
  region = "${var.region}"
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

terraform {
  backend "s3" {}
}

module "ecs" {
  source = "./../../../../../../../terraform/modules/aws/ecs/clusterEc2/"
  name = "${var.name}"
  instance_type = "${var.instance_type}"
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  desired_capacity = "${var.desired_capacity}"
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
  env = "${var.env}"
// account = "${var.account}"
  vpc_zone_identifier = ["${var.vpc_zone_identifier}"]
  security_group = ["${var.security_group}"]
  autoscaling_enabled = "${var.autoscaling_enabled}"
  sns_enabled = "${var.sns_enabled}"
}