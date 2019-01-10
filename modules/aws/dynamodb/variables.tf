variable "name" {
  description = "The name of the DynamoDB table"
  default = ""
}

variable "read_capacity" {
  description = "The Set default Read capacity"
  default = ""
}

variable "write_capacity" {
  description = "The Set default Write capacity"
  default = ""
}

variable "hash_key" {
  description = "The attribute to use as the HASH_KEY"
  default = ""
}

variable "range_key" {
  description = "The attribute to use as the RANGE_KEY"
  default = ""
}

variable "attribute_name1" {
  description = "The attribute to use as the attribute_name1"
  default = ""
}

variable "attribute_type1" {
  description = "The attribute to use as the attribute_type1"
  default = ""
}

# variable "attribute_name2" {
#   description = "The attribute to use as the attribute_name1"
#   default = ""
# }

# variable "attribute_type2" {
#   description = "The attribute to use as the attribute_type1"
#   default = ""
# }

# variable "attribute_name3" {
#   description = "The attribute to use as the attribute_name1"
#   default = ""
# }

# variable "attribute_type3" {
#   description = "The attribute to use as the attribute_type1"
#   default = ""
# }

variable "stream_enabled" {
  description = "Enable/disable (bolean) dynamodb stream"
  default = ""
}

variable "stream_view_type" {
  description = "StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES"
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
