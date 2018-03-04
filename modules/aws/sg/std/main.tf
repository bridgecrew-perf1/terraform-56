terraform {
  required_version  = "> 0.9.8"
}

/*
Security Group
*/
resource "aws_security_group" "main" {                      
  name                        = "${var.name}"
  description                 = "${var.description}"
  vpc_id                      = "${var.vpc_id}"

  ingress {
    from_port                 = "${var.igr_from}"
    to_port                   = "${var.igr_to}"
    protocol                  = "${var.igr_protocol}"
    cidr_blocks               = ["${var.igr_cidr_blocks}"]
  }
  egress {
    from_port                 = "${var.egr_from}"
    to_port                   = "${var.egr_to}"
    protocol                  = "${var.egr_protocol}"
    cidr_blocks               = ["${var.egr_cidr_blocks}"]
  }
  tags {
    Name                       = "${var.name}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}