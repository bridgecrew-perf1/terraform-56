variable "cidr" {
  description = "VPC address block"
  default     = ""
}

variable "vpc_tenancy" {
  description = "Instance type of tenancy, accepted values are default/dedicated"
  default     = ""
}

variable "enable_dns_support" {
  description = "Use if you are setting internal DNS's, default is false"
  default     = ""
}

variable "enable_dns_hostnames" {
  description = "What is the list of DNS servers"
  default     = ""
}

variable dhcp_domain_name {
  description = "The domain name for instances in this VPC"
  default = ""
}

variable "map_ip" {
  description = "Will the server have or not a public IP if on a public subnet"
  default     = false
}


variable domain_name_servers {
  description = "Search list of the IP's or FQDN of your DNS servers (WIP)"
  type = "list"
  default = []
}
/*
variable dns_ntp_servers {
  description = "Search list of the IP's or time servers (WIP)"
  defautl = []
}
*/

variable enable_dhcp {
  description = "Set to true/false if you want to use this resource"
  default = ""
}

variable azs {
  description = "List of Azs for your environment"
  default = []
}

variable public_subnets {
  description = "The IP ranges for the Public subnets"
  default = []
}

variable private_subnets {
  description = "Ranges for the VPC Private subnets"
  default = []
}

variable rds_subnets {
  description = "Ranges for the VPC Private RDS subnets"
  default = []
}

variable ecs_subnets {
  description = "Ranges for the VPC Private ECS subnets"
  default = []
}

variable rs_subnets {
  description = "Ranges for the VPC Private Redshift subnets"
  default = []
}

/*
Tags
*/
variable "name" {
  description = "Input the name of stack"
  default     = ""
}

variable "tagpro" {
  description = "The name of the project this resource belongs to"
  default     = ""
}

variable "tagenv" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "tagapp" {
  description = "The cost center"
  default     = ""
}

variable "tagown" {
  description = "The Owner of the resource"
  default     = ""
}

variable "tagmod" {
  description = "Who created this resource"
  default     = ""
}