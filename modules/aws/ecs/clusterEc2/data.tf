
// Get the latest AMI
data "aws_ami" "ecs_ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
//    values = ["amzn-ami-2018.03.j-amazon-ecs-optimized*"]
    values = ["amzn-ami-*.*.*-amazon-ecs-optimized"]
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