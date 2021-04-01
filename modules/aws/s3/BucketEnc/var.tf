variable "acl" {
  description = "The acl for the bucket"
  default     = "private"
}

variable "policy" {}

variable "destroy" {
  description = "The policy for retention of the bucket, default false"
  default     = "false"
}

variable "versioning" {
  default     = false
  description = "Keep multiple versions of an object in the same bucket. Default false"
}

variable "kms_master_key_id" { default = "" }

variable "sse_algorithm" { default = "AES256" }

/*
Tags
*/
variable "name" {
  description = "Input the name of stack"
  default     = ""
}

variable "tag_env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "other_tags" {
  description = "For adding an additional values for tags"
  type        = map(string)
  default     = {}
}

/*
Folders
*/
variable "folders" {
  type        = list(string)
  default     = []
  description = "Space separate list of top-level folders"
}

