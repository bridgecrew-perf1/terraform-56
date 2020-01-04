
// Get the latest AMI
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["${var.ami_owner}"]
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

data "aws_iam_policy_document" "asg" {
  statement {
    sid    = "ECR"
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
    sid    = "Logs"
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
    sid    = "CWAgent"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeTags"
    ]

    resources = ["*"]
  }
}

data "template_file" "init" {
  vars {
  }
  template                  = "${file("${path.module}/scripts/init.cfg")}"
}

data "template_file" "userdata" {
  vars {
    ami_architecture                  = "${var.ami_architecture}"
    loggroup                          = "${aws_cloudwatch_log_group.main.name}"
    stack_type                        = "${var.stack_type}"
    del_ec2_user                      = "${var.del_ec2_user}"
    env                               = "${var.env}"
    config_bucket                     = "${var.config_bucket}"
    secrets_bucket                    = "${var.secrets_bucket}"
    region                            = "${var.region}"

    default_port                      = "${var.port}"
    debug                             = "${var.debug_script}"
  }
  template                  = "${file("${path.module}/scripts/user_data.sh")}"
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.init.rendered}"
  }
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata.rendered}"
  }
}

//data "template_file" "dashboard" {
//   vars {
//    cluster_name             = "${aws_autoscaling_group.main.name}"
//  }
//  template                  = "${file("${path.module}/dashboard.json")}"
//
//}