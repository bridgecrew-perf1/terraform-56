variable "name" {}

variable "iam_policy_path" {}

variable "vpc_id" {}

variable "allowed_cidr" {}

variable "hport" {}

variable "cluster" {}

variable "task_definition" {}

variable "desired_count" {
  default = 0
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

variable "assign_public_ip" {
  default = true
}

variable "max_capacity" {
  default = 30
}

variable "scalable_dimension" {
  default = "ecs:service:DesiredCount"
}

variable "service_namespace" {
  default = "ecs"
}

variable "tag_project" {}

variable "env" {}

variable "tag_costcenter" {}

variable "tag_createdby" {}
