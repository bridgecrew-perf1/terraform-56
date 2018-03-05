variable "instance_iam_role" {
  description = "IAM role ARN to attach to your instances"
  default = ""
}

variable "key_name" {
  description = "The name of the key used for the initial provison, WIP rotation of it through Vault"
  default = ""
}

variable "security_groups" {
  description = "The list of security groups to use with the ASG instances"
  type = "list"
  default = []
}

variable "asg_name" {
  description = "Auto Scaling & Launch Configuration name prefix"
  default = ""
}

variable "create_asg" {
  description = "Nr of ASG's to create"
}

variable "ami_id" {
  description = "AWS image if to use"
  default = ""
}

variable "instance_type" {
  description = "The type of aws vm to use"
  default = ""
}

variable "associate_public_ip_address" {
  description = "Set true/false (without quotes)"
  default = true
}

variable "user_data" {
  description = "The inital commands to apply, use the file"
  default = ""
}

variable "enable_monitoring" {
  description = "Set true/false (without quotes)"
  default = true
}

variable "placement_tenancy" {
  description = "The type of host instance tenancy, default or dedicated, this modules are done for default"
  default = "default"
}

variable "ebs_optimized" {
  description = "Set this option to use EBS on the root device, true/false (without quotes)"
  default = true
}

variable "ebs_block_device" {
  description = "Additional EBS volumes descrition"
  type = "list"
  default = []
}

# variable "ephemeral_block_device" {
#   description = "Use if the instance type has ephemeral boot device only"
#   default = []
# }

# variable "spot_price" {
#   description = "Set if you haven't enabled placement_tenancy only"
#   default = "0.01"
# }

/*
Auto Scaling variable definition
*/

variable "root_block_device" {
  description = "Settings for the device block, value changes delete/create instance"
  type = "list"
  default = []
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

variable "min_size" {
  description = "Minimum nr of nodes on the ASG"
  default = "0"
}

variable "desired_capacity" {
  description = "The inital capacity of the ASG, must be >= to min_size"
  default = "0"
}

# variable "load_balancers" {
#   description = "List of Loadbalancers to use (optional) requires the Load Balancer module"
#   type = "list"
#   default = []
# }


# variable "health_check_grace_period" {
#   description = "Time after instance comes into service before checking health OK/KO."
#   default = "300"
# }

# variable "health_check_type" {
#   description = "Chose ELB/EC2 for the check type"
#   default = "EC2"
# }

# variable "wait_for_elb_capacity" {
#   description = "Makes min_elb_capacity irrelevant due to precedence and waits for the instances to come to healthy status"
#   default = 
# }

# variable "target_group_arns" {
#   description = "List of ALBs arns to use"
#   type = "list"
#   default = [] 
# }

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
variable "name" {
  description = "Input the name of stack"
  default     = ""
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