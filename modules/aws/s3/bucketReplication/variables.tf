variable "name" {}

variable "iam_policy_path" {
  default = "/"
}

variable "acl" {
  default = "private"
}

variable "versioning_enabled" {
  default = true
}

variable "source_account" {}

variable "region" {
  default = "eu-west-2"
}

variable "lifecycle_rule_enabled" {
  default = false
}

variable "key_usage" {
  default = "ENCRYPT_DECRYPT"
}

variable "is_enable" {
  default = true
}

variable "enable_key_rotation" {
  default = false
}

variable "deletion_window_in_days" {
  default = 30
}

variable "kms_is_enabled" {
  default = true
}

variable "s3_key_prefix" {
  default = "logs"
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
  default = "Enabled"
}

variable "s3_destination_account_id" {}

variable "storage_class" {
  default = "STANDARD_IA"
}

variable "source_selection_criteria_sse_status" {
  default = true
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
