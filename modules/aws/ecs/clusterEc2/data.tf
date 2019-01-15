
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

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOC
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = /infrastructure/ecs/$${clustername}
log_stream_name = $${groupname}/{container_instance_id}/dmesg

[/var/log/messages]
file = /var/log/messages
log_group_name = /infrastructure/ecs/$${clustername}
log_stream_name = $${groupname}/{container_instance_id}/messages
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = /infrastructure/ecs/$${clustername}
log_stream_name = $${groupname}/{container_instance_id}/docker
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log
log_group_name = /infrastructure/ecs/$${clustername}
log_stream_name = $${groupname}/{container_instance_id}/ecs-init
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = /infrastructure/ecs/$${clustername}
log_stream_name = $${groupname}/{container_instance_id}/ecs-agent
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log.*
log_group_name = /infrastructure/ecs/$${clustername}
log_stream_name = $${groupname}/{container_instance_id}/audit
datetime_format = %Y-%m-%dT%H:%M:%SZ

EOC

# Set the region to send CloudWatch Logs data to (the region where the container instance is located)
region=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

# Configure and start CloudWatch Logs agent on Amazon ECS container instance
# Grab the container instance ARN from instance metadata
container_instance_id=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r .instanceId)
# Replace the container instance ID placeholders with the actual values
sed -i -e "s/{container_instance_id}/$container_instance_id/g" /etc/awslogs/awslogs.conf
systemctl enable awslogsd
systemctl start awslogsd
--==BOUNDARY==--
EOF

}
