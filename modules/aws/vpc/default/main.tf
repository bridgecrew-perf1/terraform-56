terraform {
  required_version  = "> 0.9.8"
}

/*
VPC
*/
resource "aws_vpc" "main" {
  cidr_block                    = "${var.cidr}"
  instance_tenancy              = "${var.vpc_tenancy}"
  enable_dns_support            = "${var.enable_dns_support}"
  enable_dns_hostnames          = "${var.enable_dns_hostnames}"
  tags {
    Name                       = "${var.name}.vpc.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
DHCP options Set
*/
resource "aws_vpc_dhcp_options" "main" {
  count                         = "${length(var.public_subnets) > 0 ? 1 : 0}"
  domain_name                   = "${var.dhcp_domain_name}"
  domain_name_servers           = ["${var.domain_name_servers}"]
  # ntp_servers                = ["${var.dhcp_ntp1}", "${var.dhcp_ntp2}"]
  tags {
    Name                       = "${var.name}.dhcp.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
DHCP Options Set Association
*/
resource "aws_vpc_dhcp_options_association" "main" {
  count                         = "${var.enable_dhcp ? 1 : 0}"
  vpc_id                        = "${aws_vpc.main.id}"
  dhcp_options_id               = "${aws_vpc_dhcp_options.main.id}"
}

/*
Internet Gateway
*/
resource "aws_internet_gateway" "main" {
  count                         = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id                        = "${aws_vpc.main.id}"
  tags {
    Name                       = "${var.name}.igw.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
Publiс routes
*/
resource "aws_route_table" "public" {
  count                         = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id                        = "${aws_vpc.main.id}"
  # propagating_vgws           = ["${var.public_propagating_vgws}"]
  tags {
    Name                       = "${var.name}.rtp.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

resource "aws_route" "public_internet_gateway" {
  count                         = "${length(var.public_subnets) > 0 ? 1 : 0}"
  route_table_id                = "${aws_route_table.public.id}"
  destination_cidr_block        = "0.0.0.0/0"
  gateway_id                    = "${aws_internet_gateway.main.id}"
}

/*
Public Subnets
*/
resource "aws_subnet" "public" {
  count                         = "${length(var.public_subnets) > 0 ? length(var.private_subnets) : 0}"
  vpc_id                        = "${aws_vpc.main.id}"
  cidr_block                    = "${element(var.public_subnets, count.index)}"
  availability_zone             = "${element(var.azs, count.index)}"
  map_public_ip_on_launch       = "${var.map_ip}"
  tags {
    Name                       = "${var.name}.pubsub.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
Public Route Association
*/
resource "aws_route_table_association" "public" {
  count                        = "${length(var.public_subnets)}"
  subnet_id                    = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id               = "${aws_route_table.public.id}"
}

/*
Private routes
*/
resource "aws_route_table" "private" {
  count                        = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  tags {
    Name                       = "${var.name}.rtpri.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
Private Subnets
*/
resource "aws_subnet" "private" {
  count                        = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  cidr_block                   = "${element(var.private_subnets, count.index)}"
  availability_zone            = "${element(var.azs, count.index)}"
  tags {
    Name                       = "${var.name}.prisub.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
EIP for NAT Gateway
*/
resource "aws_eip" "nat" {
  count                        = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  vpc                          = true
}

/*
NAT Gateway
*/
resource "aws_nat_gateway" "main" {
  count                        = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  allocation_id                = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id                    = "${element(aws_subnet.public.*.id, count.index)}"
  tags {
    Name                       = "${var.name}.ntgw.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
  depends_on                   = ["aws_internet_gateway.main"]
}

resource "aws_route" "private_nat_gateway" {
  count                        = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  route_table_id               = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block       = "0.0.0.0/0"
  nat_gateway_id               = "${element(aws_nat_gateway.main.*.id, count.index)}"
}

/*
Private Route Association
*/
resource "aws_route_table_association" "private" {
  count                        = "${length(var.private_subnets)}"
  subnet_id                    = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id               = "${element(aws_route_table.private.*.id, count.index)}"
}

/*
RDS network
*/

/*
rds routes
*/
resource "aws_route_table" "rds" {
  count                        = "${length(var.rds_subnets) > 0 ? length(var.rds_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  tags {
    Name                       = "${var.name}.rtrds.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
rds Subnets
*/
resource "aws_subnet" "rds" {
  count                        = "${length(var.rds_subnets) > 0 ? length(var.rds_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  cidr_block                   = "${element(var.rds_subnets, count.index)}"
  availability_zone            = "${element(var.azs, count.index)}"
  tags {
    Name                       = "${var.name}.rdssub.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
rds Route Association
*/
resource "aws_route_table_association" "rds" {
  count                        = "${length(var.rds_subnets)}"
  subnet_id                    = "${element(aws_subnet.rds.*.id, count.index)}"
  route_table_id               = "${element(aws_route_table.rds.*.id, count.index)}"
}

/*
Redshift network
*/

/*
redshift routes
*/
resource "aws_route_table" "rs" {
  count                        = "${length(var.rs_subnets) > 0 ? length(var.rs_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  tags {
    Name                       = "${var.name}.rtrs.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
rs Subnets
*/
resource "aws_subnet" "rs" {
  count                        = "${length(var.rs_subnets) > 0 ? length(var.rs_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  cidr_block                   = "${element(var.rs_subnets, count.index)}"
  availability_zone            = "${element(var.azs, count.index)}"
  tags {
    Name                       = "${var.name}.rssub.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
rs Route Association
*/
resource "aws_route_table_association" "rs" {
  count                        = "${length(var.rs_subnets)}"
  subnet_id                    = "${element(aws_subnet.rs.*.id, count.index)}"
  route_table_id               = "${element(aws_route_table.rs.*.id, count.index)}"
}
