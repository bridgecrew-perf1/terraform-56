
// Get the latest AMI
data "aws_ami" "ecs_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["${var.ami_owner}"]
  }
  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
  filter {
    name   = "architecture"
    values = ["${var.ami_architecture}"]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_cluster" {
  statement {
    sid    = "ECSECR"
    effect = "Allow"

    actions = [
      "application-autoscaling:*",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecs:UpdateContainerAgent",
      "ecs:UpdateContainerInstancesState",
      "ecs:UpdateService",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ECSLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:Describe*"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid    = "ECSCWAgent"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeTags"
    ]

    resources = ["*"]
  }
}

data "template_file" "user_data" {
   vars {
    clustername             = "${var.name}"
    groupname               = "${var.name}"
    loglevel                = "${var.name}"
    workload                = "${var.name}"
    owner                   = "${var.tag_project}"
  }
  template                  = <<EOF
Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
Content-Type: text/cloud-boothook; charset="us-ascii"

# Install awslogs
cloud-init-per once yum_update yum update -y
cloud-init-per once install_cloudwatch_logs_agent yum install -y awslogs jq

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set any ECS agent configuration options
cat <<'EOC' >> /etc/ecs/ecs.config
ECS_CLUSTER=$${clustername}
ECS_LOGLEVEL=$${loglevel}
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]
ECS_CONTAINER_START_TIMEOUT=10m
ECS_RESERVED_MEMORY=256
ECS_INSTANCE_ATTRIBUTES={"workload": "$${workload}"}
ECS_CONTAINER_INSTANCE_TAGS={"owner": "$${owner}","workload": "$${workload}"}
EOC

EOF

}
