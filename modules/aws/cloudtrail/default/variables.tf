variable "name" {
  description = "The name of the cloudtrail"
  default = ""
}

variable "bucket_name" {
  description = "The name of the bucket - for the account level this should have been created with shell script"
  default = ""
}

variable "s3_key_prefix" {
  description = "Use it as you could write different trails to the same bucket (maybe)"
  default = ""
}

variable "enable_logging" {
  description = "This should always be true"
  default = "true"
}

variable "include_global_service_events" {
  description = "Bool. as should also always be true"
  default = ""
}

variable "enable_log_file_validation" {
  description = "Bool. verify log integraty"
  default = ""
}

variable "kms_key_id" {
  description = "The Kms key to encrypt the logs"
  default = ""
}

variable "read_write_type" {
  description = "The type of events ReadOnly, WriteOnly, All"
  default = ""
}

variable "include_management_events" {
  description = "Specifies whether the trail is publishing events from global services such as IAM to the log files. Defaults to true"
  default = ""
}

variable "is_multi_region_trail" {
  description = "Enable on all regions within the account"
  default = ""
}

/*
Tags
*/
variable "tag_env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "other_tags" {
  description = "For adding an additional values for tags"
  type = "map"
  default = {}
}
