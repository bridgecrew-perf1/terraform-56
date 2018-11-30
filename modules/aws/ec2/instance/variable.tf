variable "ami" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "iam_instance_profile" {}

variable "availability_zone" {}

variable "ebs_optimized" {
  defautl = false
}

variable "disable_api_termination" {
  default = false
}

variable "key_name" {}

variable "monitoring" {
  description = "Detailed monitoring - additional costs"
  default = false
}

variable "security_groups" {
  type = "list"
}

variable "source_dest_check" {
  description = "Bollean, default to true, set to false if the instance is a VPN; Proxy or NatGW instance"
  default = true
}

variable "user_data" {}

variable "volume_type" {
  default = "standard"
}

variable "volume_size" {
  description = "Min 10 for Linux flavours and 60 for windows flavours"
  default = 10
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