variable "name" {
  description = "The name for the task definition"
  default = ""
}

variable "container_definitions" {
  description = "The container definition settings"
  default = ""
}

variable "iam_role_arn" {
  description = "The role to assume by the task"
  default = ""
}

variable "network_mode" {
  description = "The task network mode"
  default = ""
}

variable "image" {
  description = "the full path to the image with repo/image"
  default = ""
}

variable "essential" {
  description = "When using more than one container on a task this means that if this fails/stops all will stop"
  default = ""
}

variable "cport" {
  description = "The container port"
  default = ""
}

variable "hport" {
  description = "The host port to map the container port to"
  default = ""
}

variable "env_variables" {
  description = "Environment variables which you want to feed to the container"
  type = "list"
  default = []
}

variable "entrypoint" {
  description = "The command(s) used to start the container"
  type = "list"
  default = ""
}

variable "log_driver" {
  description = "The type of log driver to use for this container"
  default = ""
}

variable "log_group" {
  description = "The Cloudwatch log group"
  default = ""
}

variable "region" {
  description = "The region for the log group"
  default = ""
}


