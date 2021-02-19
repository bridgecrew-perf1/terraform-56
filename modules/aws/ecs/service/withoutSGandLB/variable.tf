variable "name" {}

variable "iam_policy_path" {
  default = "/"
}

variable "cpu" {
  default = 256
}

variable "memory" {
  default = 1024
}

variable "security_groups" {
  type = "list"
}

variable "cluster" {}

variable "container_definitions" {}

variable "desired_count" {
  default = 1
}

variable "launch_type" {
  default = "FARGATE"
}

variable "network_mode" {
  default = "awsvpc"
}

variable "subnets" {
  type = "list"
}

variable "max_capacity" {
  default = 30
}

variable "tag_env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "other_tags" {
  description = "For adding an additional values for tags"
  type        = "map"
  default     = {}
}

variable "task_role_arn" {
  description = "ARN of the IAM role that allows ECS to make calls to other AWS services"
}
