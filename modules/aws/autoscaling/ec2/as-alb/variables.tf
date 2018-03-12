/*
Auto Scaling variable definition
*/

variable "name" {
  description = "Input the name of stack"
  default     = ""
}

variable "as_version" {
  description = "The version og the config to avoid naming conflict"
  default = ""
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs for the ec2 instances"
  type = "list"
  default = []
}

variable "max_size" {
  description = "Maximum nr of nodes on the ASG"
  default = "10"
}

variable "launch_configuration" {
  description = "The id of the launch configuration"
  default = ""
}

variable "min_size" {
  description = "Minimum nr of nodes on the ASG"
  default = "0"
}

variable "desired_capacity" {
  description = "The inital capacity of the ASG, must be >= to min_size"
  default = "0"
}

variable "load_balancers" {
  description = "List of Loadbalancers to use (optional) requires the Load Balancer module"
  type = "list"
  default = []
}


variable "health_check_grace_period" {
  description = "Time after instance comes into service before checking health OK/KO."
  default = "300"
}

variable "health_check_type" {
  description = "Chose ELB/EC2 for the check type"
  default = "EC2"
}

variable "wait_for_elb_capacity" {
  description = "Makes min_elb_capacity irrelevant due to precedence and waits for the instances to come to healthy status"
  default = 
}

variable "target_group_arns" {
  description = "List of ALBs arns to use"
  type = "list"
  default = [] 
}

variable "default_cooldown" {
  description = "Default time to wait before scaling up/down"
  default = ""
}

variable "force_delete" {
  description = "Forces the deletion of the ASG even if not all instances are terminated, true/false"
  default = false
}

variable "termination_policies" {
  description = "OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
  type = "list"
  default = ["Default"]
}

# variable "suspended_processes" {
#   description = "Allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer"
#   default = ""
# }

# variable "placement_group" {
#   description = "The name of the placement group, instances cannot be spanned across multiple AZs"
#   default = ""
# }

variable "enabled_metrics" {
  description = "Allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type = "list"
  default = []
}

variable "wait_for_capacity_timeout" {
  description = "Amount of time terraform waits before moving no"
  default = "0"
}

variable "protect_from_scale_in" {
  description = "Select this option for the instances to be protected from deletion on scale in, true/false"
  default = ""
}

/*
Tags
*/

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