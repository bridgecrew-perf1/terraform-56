
/*
Auto Scaling variable definition
*/

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs for the ec2 instances"
  type = "list"
  default = []
}

variable "max_size" {
  description = "Maximum nr of nodes on the ASG"
  default = "10"
}

variable "min_size" {
  description = "Minimum nr of nodes on the ASG"
  default = "0"
}

variable "desired_capacity" {
  description = "The inital capacity of the ASG, must be >= to min_size"
  default = "0"
}

variable "default_cooldown" {
  description = "Default time to wait before scaling up/down"
  default = "180"
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


variable "enabled_metrics" {
  description = "Allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type = "list"
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
}

variable "wait_for_capacity_timeout" {
  description = "Amount of time terraform waits before moving no"
  default = "0"
}

variable "protect_from_scale_in" {
  description = "Select this option for the instances to be protected from deletion on scale in, true/false"
  default = false
}

// SSH Key
variable "algorithm" {
  default = "RSA"
}

variable "rsa_bits" {
  default = "4096"
}

// Security Group

variable "vpc_id" {
  default = ""
}

variable "igr_from" {
  default = "22"
}

variable "igr_to" {
  default = "22"
}

variable "igr_protocol" {
  default = "tcp"
}

variable "igr_cidr_blocks" {
  type = "list"
  default = ["0.0.0./0"]
}

variable "igr_security_groups" {
  type = "list"
  default = []
}

variable "egr_security_groups" {
  type = "list"
  default = []
}
// Launch Template

variable "instance_type" {
  default = "a1.medium"
}

variable "device_name_root" {
  default = "/dev/xvda"
}

variable "volume_size_root" {
  default = "80"
}

variable "volume_type_root" {
  default = "gp2"
}

variable "delete_on_termination_root" {
  default = true
}

variable "encrypted_root" {
  default = false
}

variable "device_name_ecs" {
  default = "/dev/xvdb"
}

variable "volume_size_ecs" {
  default = "100"
}

variable "volume_type_ecs" {
  default = "gp2"
}

variable "delete_on_termination_ecs" {
  default = true
}

variable "encrypted_ecs" {
  default = false
}

variable "ebs_optimized" {
  default = true
}

variable "disable_api_termination" {
  default = false
}

variable "instance_initiated_shutdown_behavior" {
  default = "terminate"
}

variable "monitoring_enabled" {
  default = true
}

variable "associate_public_ip_address" {
  default = false
}

variable "delete_on_termination" {
  default = true
}

variable "vpc_security_group_ids" {
  type = "list"
}

/*
Tags
*/
variable "name" {
  description = "The name of the ECS cluster"
  default = ""
}

variable "tag_project" {
  description = "The name of the project this resource belongs to"
  default     = ""
}

variable "env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "tag_costcenter" {
  description = "The cost center"
  default     = ""
}

variable "tag_modifiedby" {
  description = "The Owner of the resource"
  default     = ""
}

variable "tag_modifydate" {
  description = "Who created this resource"
  default     = ""
}