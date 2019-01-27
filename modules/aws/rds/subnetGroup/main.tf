resource "aws_db_subnet_group" "main" {
  name                        = "${var.name}"
  subnet_ids                  = ["${var.subnet_ids}"]
  description                 = "${var.name} RDS Subnet Group"
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}