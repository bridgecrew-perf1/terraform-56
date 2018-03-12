variable "name" {
  description = "The name of the target group"
  default = ""
}

variable "port" {
  description = "The port the LB is listening too"
  default = ""
}

variable "protocol" {
  description = "The target group protocol"
  default = ""
}

variable "vpc_id" {
  description = "The id of the vpc where the containers/instances are connected to"
  default = ""
}

variable "deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused, changed it when you need above the default 300 sec"
  default = ""
}

variable "stickiness_type" {
  description = "The only current possible value is lb_cookie"
  default = ""
}

variable "stickiness_cookie_duration" {
  description = "The time period, in seconds, during which requests from a client should be routed to the same target, default is 1 day, mon 1 sec"
  default = ""
}

variable "stickiness_enabled" {
  description = "Boolean value"
  default = ""
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks; default 30sec min 5sec max 300sec"
  default = ""
}

variable "health_check_path" {
  description = "The path for the health check, default / or for example ping/ if defined on the app"
  default = ""
}

variable "health_check_port" {
  description = "The testing port if different from the app"
  default = ""
}

variable "health_check_protocol" {
  description = "HTTP; HTTPS; TCP"
  default = ""
}

variable "health_check_timeout" {
  description = "The time to consider the HC failed"
  default = ""
}

variable "health_check_healthy_threshold" {
  description = "The nr of times to try before setting the node as failed"
  default = ""
}

variable "health_check_unhealthy_threshold" {
  description = "The nr of times to try before setting the node as failed"
  default = ""
}

variable "health_check_threshold" {
  description = "The nr of times to try before setting the node as failed"
  default = ""
}

variable "health_check_matcher" {
  description = "HTTP codes to expect when successful"
  default = ""
}

variable "target_type" {
  description = " The type of target, can be instance or ip"
  default = ""
}

/*
Tags
*/

variable "tag_alb" {
  description = "Used to prevent the target to be created before the ALB which takes longer"
}

variable "tag_project" {
  description = "The name of the project this resource belongs to"
  default     = ""
}

variable "tag_env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "tag_costcenter" {
  description = "The cost center"
  default     = ""
}

variable "tag_createdby" {
  description = "Who created this resource"
  default     = ""
}
