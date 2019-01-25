variable "name" {}

variable "iam_policy_path" {
  default = "/"
}

variable "lg_retention_in_days" {
  default = 720
}

variable "acl" {
  default = "private"
}

variable "versioning_enabled" {
  default = false
}

variable "region" {
  default = "eu-west-1"
}

variable "lifecycle_rule_enabled" {
  default = false
}

variable "key_usage" {
  default = "ENCRYPT_DECRYPT"
}

variable "is_enable" {}

variable "enable_key_rotation" {}

variable "deletion_window_in_days" {}

variable "kms_is_enabled" {
  default = true
}

variable "s3_key_prefix" {
  default = "logs/"
}

variable "transition_days" {
  default = 90 # 3 months
}

variable "transition_storage_class" {
  default = "STANDARD_IA"
}

variable "expirition_days" {
  default = 720 # 2 years
}

variable "replication_configuration_status" {
  default = false
}

variable "$s3_destinatino_bucket_arn" {}

variable "storage_class" {
  default = "STANDARD_IA"
}

variable "object_lock_configuration_enabled" {
  default = true
}

variable "object_lock_configuration_default_retention_mode" {
  description = "Governance - you can delete; Compliance you cannot delete"
  default = "Governance"
}

variable "object_lock_configuration_default_retention_days" {
  default = 720
}

variable "cloud_watch_logs_role_arn" {}

variable "cloud_watch_logs_group_arn" {}

variable "enable_logging" {
  default = true
}

variable "include_global_service_events" {
  default = true
}

variable "include_global_service_events" {
  default = true
}

variable "is_multi_region_trail" {
  default = true
}

variable "enable_log_file_validation" {
  default = true
}

variable "kms_key_id" {}

variable "read_write_type" {
  default = "All"
}

variable "include_management_events" {
  default = true
}

variable "lambda_arns" {
  type = "list"
}

variable "s3_arns" {
  type = "list"
}

variable "force_destroy" {
  default = false
}

// Tags
variable "tag_project" {}

variable "env" {}

variable "tag_costcenter" {}

variable "tag_modifiedby" {}

variable "account" {}