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

variable "region" {}

variable "account" {}

variable "vpc_id" {}

variable "allowed_cidr" {
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "hport" {
  default = 80
}

variable "security_groups" {
  type = "list"
}

variable "cluster" {}

variable "container_definitions" {}

variable "volume_name" {}

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

variable "tag_modifiedby" {}

//variable "entrypoint" {
//  type = "list"
//}

variable "policy" {}

variable "assume_role_policy" {}