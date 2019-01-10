terraform {
  required_version  = "> 0.11.2"
}

resource "aws_dynamodb_table" "main" {
  name           = "${var.name}"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "${var.hash_key}"
  # range_key      = "${var.range_key}"
  attribute {
    name = "${var.attribute_name1}"
    type = "${var.attribute_type1}"
  }
  # attribute {
  #   name = "${var.attribute_name2}"
  #   type = "${var.attribute_type2}"  
  # }
  # attribute {
  #   name = "${var.attribute_name3}"
  #   type = "${var.attribute_type3}"
  # }
  stream_enabled = "${var.stream_enabled}"
  stream_view_type = "${var.stream_view_type}"
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}