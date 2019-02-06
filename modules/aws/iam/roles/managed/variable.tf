variable "name" {}

variable "iam_policy_path" {
  description = "IAM policy doc for permissions"
  default = "/"
}

variable "policy_arn" {}

variable "assume_role_policy" {}