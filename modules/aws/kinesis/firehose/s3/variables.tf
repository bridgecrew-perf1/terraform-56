variable "name" {
  description = "The name of the Kinesis stream"
  default = ""
}

variable "dest" {
  description = "The Stream destination, by default for this module it's s3"
  default = "s3"
}

variable "iam_role_arn" {
  description = "The arn for the iam role"
  default = ""
}

variable "bucket_arn" {
  description = "The s3 bucket arn where the streams are stored"
  default = ""
}

variable "buffer_size" {
  description = "Buffer incoming data to the specified size, in MBs"
  default = ""
}

variable "buffer_interval" {
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination"
  default = ""
}

variable prefix {
  description = "The key on the bucket"
  default = ""
}

variable "compression_format" {
  description = "The format to store files in s3, the accepted values are UNCOMPRESSED (default) GZIP; ZIP and Snappy"
  default = "UNCOMPRESSED"
}

variable "kms_arn" {
  description = "The KMS key arn, logs should always be delivered encrypted even using the default kms key"
}

variable "logging_status" {
  description = "The status of cloudwatch logging in true/false"
  default = "false"
}

variable "log_group_name" {
  description = ""
  default = "default"
}

variable "log_stream_name" {
  description = ""
  default = "default"
}

/*
Tags
*/
variable "name" {
  description = "Input the name of stack"
  default     = ""
}

variable "tag_project" {
  description = "The name of the project this resource belongs to"
  default     = ""
}

variable "tag_env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "tag_costcenter" {
  description = "The cost center"
  default     = ""
}

variable "tag_createdby" {
  description = "Who created this resource"
  default     = ""
}