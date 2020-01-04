/*
Auto Scaling variable definition
*/

variable "ami_owner" {
  default = "amazon"
}

variable "ami_name" {
  default = "amzn2-ami-hvm-2.0.*"
}

variable "ami_architecture" {
  default = "arm64"
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs for the ec2 instances"
  type = "list"
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
  default = "120"
}

variable "force_delete" {
  description = "Forces the deletion of the ASG even if not all instances are terminated, true/false"
  default = false
}

variable "health_check_grace_period" {
  default = 300
}

variable "health_check_type" {
  default = "EC2"
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

variable "stack_type" {
  description = "Select the location of the ssh files on S3 to use ex. bastion; ecs"
  default = "bastion"
}

variable "del_ec2_user" { default = "true" }

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
  default = ["0.0.0.0/0"]
}

variable "port" {
  default = "22"
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

variable "ebs_encrypted" { default = false }

variable "ebs_kms_key_id" { default = "" }

variable "delete_on_termination_root" {
  default = true
}

variable "encrypted_root" {
  default = false
}

//variable "delete_on_termination_ecs" {
//  default = true
//}
//
//variable "encrypted_ecs" {
//  default = false
//}

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

variable "debug_script" {
  description = "Enable set -x option for userdatam use 'off' or 'on' as valus"
  default = "off"
}
//variable "ecs_log_level" {
//  default = "info"
//}

variable "config_bucket" {}

variable "secrets_bucket" {}

variable "region" {}


// Autoscaling variables and values

//variable "policy_type" {
//  default = "TargetTrackingScaling"
//}
//variable "estimated_instance_warmup" {
//  default = "120"
//}
//variable "metric_dimension_name" {
//  default = "ClusterName"
//}
//variable "metric_dimension_metric_name_cpu" {
//  default = "CpuReservation"
//}
//
//variable "metric_dimension_metric_name_mem" {
//  default = "MemoryReservation"
//}
//
//
//variable "metric_dimension_statistic_cpu" {
//  default = "Average"
//}
//
//variable "metric_dimension_statistic_mem" {
//  default = "Average"
//}

variable "average_target_value_cpu" {
  default = 50
}

variable "target_value_mem" {
  default = 60
}

// Alarms
variable "sns_notifications" {
  type = "list"
  default = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
}

variable "autoscaling_enabled" {}

variable "sns_enabled" {}

variable "sns_topic_arn" { default = "" }

variable "env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

/*
Tags
*/

variable "name" {
  description = "The name of the stack"
  default = ""
}

variable "tag_env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "other_tags" {
  description = "For adding an additional values for tags"
  type = "map"
  default = {}
}

