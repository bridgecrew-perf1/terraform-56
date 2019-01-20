terraform {
  required_version  = "> 0.11.2"
}

resource "aws_ecs_task_definition" "main" {
  family                = "${var.name}"
  task_role_arn = "${var.iam_role_arn}"
  # execution_role_arn = "${var.execution_role_arn}"
  network_mode = "${var.network_mode}"
  # volume {
  #   name      = "service-storage"
  #   host_path = "/ecs/service-storage"
  # }
  container_definitions = <<DEFINITION
{
  "containerDefinitions": [
    {
      "name": "${name}",
      "image": "${var.image}",
      "essential": "${var.essential}",
      "portMappings": [
        {
          "containerPort": "${var.cport}",
          "hostPort": "${var.hport}"
        }
      ],
      "memory": "${var.memory}",
      "cpu": "${var.cpu}"
    },
    {
      "environment": [
        "${var.env_variables}"
      ],
      "command": [
        "${var.entrypoint}"
      ],
      "logConfiguration": {
        "logDriver": "${var.log_driver}",
        "options": {
          "awslogs-group": "${var.log_group}",
          "awslogs-region": "${var.region}"
        }
      }
    }
  ],
  "family": "${var.name}",
  "taskRoleArn": "${var.iam_role_arn}"
}
DEFINITION
}