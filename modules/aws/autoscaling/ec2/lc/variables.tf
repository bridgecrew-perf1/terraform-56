variable "count" {
  description = "The nr of ASGs"
  default = ""
}

variable "name" {
  description = "The name of the asg"
  default = ""
}

variable "lc_version" {
  description = "The version of the config to avoid naming conflict"
  default = ""
}

variable "ami_id" {
  description = "AWS image if to use"
  default = ""
}

variable "instance_type" {
  description = "The type of aws vm to use"
  default = ""
}

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

variable "root_block_device" {
  description = "Settings for the device block, value changes delete/create instance"
  type = "list"
  default = []
}

# variable "spot_price" {
#   description = "Set if you haven't enabled placement_tenancy only"
#   default = "0.01"
# }

