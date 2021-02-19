terraform {
  required_version  = "> 0.11.12"
}

// IAM Role
resource "aws_iam_instance_profile" "main" {
  name                        = "${var.name}-task"
  path                        = "${var.iam_policy_path}"
  role                        = "${aws_iam_role.main.name}"
}

resource "aws_iam_role" "main" {
  description                 = "${var.name} ECS Service IAM Role"
  name                        = "${var.name}-task"
  path                        = "${var.iam_policy_path}"
  assume_role_policy          = "${var.assume_role_policy}"
}

resource "aws_iam_policy" "main" {
    name                      = "${var.name}-pol"
    description               = "${var.name} ECS Service IAM policy"
    path                      = "${var.iam_policy_path}"
    policy                    = "${var.policy}"
}

resource "aws_iam_policy_attachment" "main" {
    name                      = "${var.name}"
    roles                     = ["${aws_iam_role.main.name}"]
    policy_arn                = "${aws_iam_policy.main.arn}"
}

resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/ecs/${var.cluster}/apps/${var.tag_env}/${var.name}"
  tags = "${merge(map(
    "Name", "${var.name}",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}

// Security Group
resource "aws_security_group" "main" {
  name                        = "${var.name}-service"
  description                 = "Allow Servie inbound (specific )& all outbound traffic"
  vpc_id                      = "${var.vpc_id}"

  ingress {
    from_port                 = "${var.container_port}"
    to_port                   = "${var.container_port}"
    protocol                  = "tcp"
    cidr_blocks               = ["${var.ing_cidr_blocks}"]
  }
  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["${var.egr_cidr_blocks}"]
  }
  tags = "${merge(map(
    "Name", "${var.name}-service",
    "Environment", "${var.tag_env}"),
    var.other_tags
  )}"
}

// Autoscaling Target Resources

resource "aws_appautoscaling_target" "main" {
  count               = "${var.as_target == true ? 1 : 0}"
  max_capacity        = "${var.max_capacity}"
  min_capacity        = "${var.desired_count}"
  resource_id         = "service/${var.cluster}/${var.name}"
  scalable_dimension  = "${var.scalable_dimension}"
  service_namespace   = "${var.service_namespace}"
}