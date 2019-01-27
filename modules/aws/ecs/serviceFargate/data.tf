
// IAM Task and service

data "aws_iam_policy_document" "assume_role_task" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "task" {
  statement {
    sid = "taskECR"
    effect = "Allow"
    actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
        ]
    resources = ["*"]
  }
  statement {
    sid = "taskLogs"
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:ListTagsLogGroup",
        "logs:PutLogEvents"
        ]
      resources = ["arn:aws:logs:${var.region}:${var.account}:log-group:/aws/ecs/${var.cluster}/services/${var.name}:*"]
  }
}