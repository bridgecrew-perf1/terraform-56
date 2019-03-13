variable "name" {}

variable "alb_internal" {
  description = "Boolean, set the type of ip for the LB"
  default = "false"
}

variable "load_balancer_type" {
  description = "Set the App lb type, can be application or network"
  default = "application"
}

variable "alb_security_groups" {
  description = "The security group(s) of the LB"
  type = "list"
  default = [""]
}

variable "alb_subnets" {
  description = "The subnets to listen from"
  type = "list"
  default = [""]
}

variable "alb_enable_deletion_protection" {
  description = "Boolean, useful if you have multiple targets - avoids wide spread impact if deleted"
  default = false
}

variable "alb_log_bucket" {
  description = "The bucket to store the access logs"
  default = ""
}

variable "alb_bucket_prefix" {
  description = "The prefix key to use on the log files"
  default = "elb"
}
// Listener SSL


variable "listener_port" {
  description = "The port the Load Balancer is listening"
  default = "443"
}

variable "listener_protocol" {
  description = "The ptotocol for connections from clients to the Load Balancer"
  default = "HTTPS"
}

variable "listener_ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS"
  default = "ELBSecurityPolicy-2016-08"
}

variable "listener_certificate_arn" {}

variable "listener_default_action_type" {
  description = "The type of routing action. The only valid value is forward"
  default = "forward"
}

// Target Group

variable "target_port" {
  description = "The port the LB is listening too"
  default = 443
}

variable "target_protocol" {
  description = "The target group protocol"
  default = "HTTP"
}

variable "vpc_id" {}

variable "target_deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused, changed it when you need above the default 300 sec"
  default = 300
}

variable "target_proxy_protocol_v2" {
  default = false
}
variable "target_stickiness_type" {
  description = "The only current possible value is lb_cookie"
  default = "lb_cookie"
}

variable "target_stickiness_cookie_duration" {
  description = "The time period, in seconds, during which requests from a client should be routed to the same target, default is 1 day, mon 1 sec"
  default = 86400
}

variable "target_stickiness_enabled" {
  description = "Boolean value"
  default = false
}

variable "target_health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks; default 30sec min 5sec max 300sec"
  default = 10
}

variable "target_health_check_path" {
  description = "The path for the health check, default / or for example ping/ if defined on the app"
  default = "/"
}

variable "target_health_check_port" {
  description = "The testing port if different from the app"
  default = 80
}

variable "target_health_check_protocol" {
  description = "HTTP; HTTPS; TCP"
  default = "HTTP"
}

variable "target_health_check_timeout" {
  description = "The time to consider the HC failed"
  default = 5
}

variable "target_health_check_healthy_threshold" {
  description = "The nr of times to try before setting the node as failed"
  default = 3
}

variable "target_health_check_unhealthy_threshold" {
  description = "The nr of times to try before setting the node as failed"
  default = 3
}

variable "target_health_check_threshold" {
  description = "The nr of times to try before setting the node as failed"
  default = 3
}

variable "target_health_check_matcher" {
  description = "HTTP codes to expect when successful"
  default = "200-299"
}

variable "target_type" {
  description = " The type of target, can be instance or ip"
  default = "instance"
}
/*
Tags
*/

variable "tag_project" {
  description = "The name of the project this resource belongs to"
  default     = ""
}

variable "tag_env" {
  description = "The environment this resource is being deployed to"
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