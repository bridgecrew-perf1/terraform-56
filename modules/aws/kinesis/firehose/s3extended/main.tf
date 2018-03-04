terraform {
  required_version  = "> 0.9.8"
}

resource "aws_kinesis_firehose_delivery_stream" "main" {
  name        = "${var.name}"
  destination = "${var.dest}"
  s3_configuration {
    role_arn   = "${var.iam_role_arn}"
    bucket_arn = "${var.bucket_arn}"
    buffer_size        = "${var.buffer_size}"
    buffer_interval    = "${var.buffer_interval}"
    compression_format = "${var.compression_format}"
    prefix = "${var.prefix}"
    kms_key_arn = "${var.kms_arn}"
    processing_configuration = [
      {
        enabled = "true"
        processors = [
          {
            type = "Lambda"
            parameters = [
              {
                parameter_name = "LambdaArn"
                parameter_value = "${var.lambda_arn}:${var.lambda_version}"
              }
            ]
          }
        ]
      }
    ],
    cloudwatch_logging_options {
      enabled = "${var.logging_status}"
      log_group_name = "${var.log_group_name}"
      log_stream_name = "${var.log_stream_name}"
    }
  }
  # tags {
  #   Name                       = "${var.name}.vpc.${count.index}"
  #   Project                    = "${var.tag_project}"
  #   Environment                = "${var.tag_env}"
  #   awsCostCenter              = "${var.tag_costcenter}"
  #   CreatedBy                  = "${var.tag_createdby}"
  # }
}