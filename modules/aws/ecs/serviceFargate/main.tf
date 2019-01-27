terraform {
  required_version  = "> 0.11.2"
}

// IAM Role
resource "aws_iam_instance_profile" "main" {
  name                        = "${var.name}_ecs_service_iam_role"
  path                        = "${var.iam_policy_path}"
  role                        = "${aws_iam_role.main.name}"
}

resource "aws_iam_role" "main" {
  description                 = "${var.name} ECS Service IAM Role"
  name                        = "${var.name}._ecs_service_iam_role"
  path                        = "${var.iam_policy_path}"
  assume_role_policy          = "${data.aws_iam_policy_document.assume_role_task.json}"
}

resource "aws_iam_policy" "main" {
    name                      = "${var.name}.iam_pol"
    description               = "${var.name} ECS Service IAM policy"
    path                      = "${var.iam_policy_path}"
    policy                    = "${data.aws_iam_policy_document.task.json}"
}

resource "aws_iam_policy_attachment" "main" {
    name                      = "${var.name}"
    roles                     = ["${aws_iam_role.main.name}"]
    policy_arn                = "${aws_iam_policy.main.arn}"
}

resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/ecs/${var.cluster}/services/${var.name}"
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_modifiedby}"
  }
}

// Security Group
resource "aws_security_group" "main" {
  name                        = "allow_all"
  description                 = "Allow ssh inbound & all outbound traffic"
  vpc_id                      = "${var.vpc_id}"

  ingress {
    from_port                 = "${var.hport}"
    to_port                   = "${var.hport}"
    protocol                  = "tcp"
    cidr_blocks               = "${var.allowed_cidr}"
  }
  egress {
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    cidr_blocks               = ["0.0.0.0/0"]
  }
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_modifiedby}"
  }
}

// ECS Service and Task Definition
resource "aws_ecs_service" "main" {
  name            = "${var.name}"
  cluster         = "${var.cluster}"
  task_definition = "${aws_ecs_task_definition.main.id}"
  desired_count   = "${var.desired_count}"
  launch_type     = "${var.launch_type}"
  iam_role        = "${aws_iam_role.main.arn}"
  network_configuration {
    subnets = ["${var.subnets}"]
    assign_public_ip = "${var.assign_public_ip}"
    security_groups = ["${aws_security_group.main.id}"]
  }
  depends_on      = ["aws_ecs_task_definition.main"]
}

resource "aws_ecs_task_definition" "main" {
  family                = "${var.name}"
  task_role_arn = "${aws_iam_role.main.arn}"
  network_mode = "${var.network_mode}"
//  volume {
//    name      = "docker.sock"
//    host_path = "/ecs/service-storage"
//  }
  container_definitions = "${var.container_definitions}"
  depends_on = ["aws_iam_role.main"]
}

resource "aws_appautoscaling_target" "main" {
  max_capacity       = "${var.max_capacity}"
  min_capacity       = "${var.desired_count}"
  resource_id        = "${aws_ecs_service.main.id}"
  scalable_dimension = "${var.scalable_dimension}"
  service_namespace  = "${var.service_namespace}"
  depends_on = ["aws_ecs_service.main"]
}