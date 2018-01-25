variable "name" {
  description = "Name of the Role and Policy"
  default = ""
}

variable "iam_policy_path" {
  description = "IAM policy doc for permissions"
  default = "/"
}

variable "iam_policy_doc" {
  description = "ASG policy document, recommended to use a file when you are defining your stack"
  default = ""
}
