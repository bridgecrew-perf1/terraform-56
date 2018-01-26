terraform {
  required_version  = "0.9.8"
}

/*
VPC
*/
resource "aws_vpc" "mod" {
  cidr_block                   = "${var.cidr}"
  instance_tenancy             = "${var.vpc_tenancy}"
  enable_dns_support           = "${var.enable_dns_support}"
  enable_dns_hostnames         = "${var.enable_dns_hostnames}"
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
resource "aws_vpc_dhcp_options" "mod" {
  count                        = "${length(var.public_subnets) > 0 ? 1 : 0}"
  domain_name                  = "${var.dhcp_domain_name}"
  domain_name_servers          = "${var.dhcp_dns_name_servers}"
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
resource "aws_vpc_dhcp_options_association" "mod" {
  count                        = "${var.enable_dhcp ? 1 : 0}"
  vpc_id                       = "${aws_vpc.mod.id}"
  dhcp_options_id              = "${aws_vpc_dhcp_options.mod.id}"
}

/*
Public Subnets
*/
resource "aws_subnet" "public" {
  count                        = "${length(var.public_subnets) > 0 ? length(var.private_subnets) : 0}"
  vpc_id                       = "${aws_vpc.mod.id}"
  cidr_block                   = "${element(var.public_subnets, count.index)}"
  availability_zone            = "${element(var.azs, count.index)}"
  map_public_ip_on_launch      = true
  tags {
    Name                       = "${var.name}.pub.subnet.${count.index}"
    Project                    = "${var.tag_project}"
    Environment                = "${var.tag_env}"
    awsCostCenter              = "${var.tag_costcenter}"
    CreatedBy                  = "${var.tag_createdby}"
  }
}

/*
Internet Gateway
*/
resource "aws_internet_gateway" "mod" {
  count                        = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id                       = "${aws_vpc.mod.id}"
  tags {
    Name                       = "${var.name}.ig.${count.index}"
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
  count                        = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id                       = "${aws_vpc.mod.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mod.id}"
  }
  # propagating_vgws           = ["${var.public_propagating_vgws}"]
  tags {
    Name                       = "${var.name}.pub.rt.${count.index}"
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
Private Subnets
*/
resource "aws_subnet" "private" {
  count                       = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  vpc_id                      = "${aws_vpc.mod.id}"
  cidr_block                  = "${element(var.private_subnets, count.index)}"
  availability_zone           = "${element(var.azs, count.index)}"
  tags {
    Name                      = "${var.name}.priv.subnet.${count.index}"
    Project                   = "${var.tag_project}"
    Environment               = "${var.tag_env}"
    awsCostCenter             = "${var.tag_costcenter}"
    CreatedBy                 = "${var.tag_createdby}"
  }
}

/*
Private route tables
*/
resource "aws_route_table" "private" {
  count                        = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  vpc_id                       = "${aws_vpc.mod.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.mod.*.id, count.index)}"
  }
  tags {
    Name                       = "${var.name}.pri.rt.${count.index}"
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
  count                       = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  vpc                         = true
}

/*
NAT Gateway
*/
resource "aws_nat_gateway" "mod" {
  count                        = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  allocation_id                = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id                    = "${element(aws_subnet.public.*.id, count.index)}"
  # tags {
  #   Name                       = "${var.name}.nat_gw.${count.index}"
  #   Project                    = "${var.tag_project}"
  #   Environment                = "${var.tag_env}"
  #   awsCostCenter              = "${var.tag_costcenter}"
  #   CreatedBy                  = "${var.tag_createdby}"
  # }
  depends_on = ["aws_internet_gateway.mod"]
}

/*
Private Route Association
*/
resource "aws_route_table_association" "private" {
  count                       = "${length(var.private_subnets) > 0 ? length(var.private_subnets) : 0}"
  subnet_id                   = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id              = "${element(aws_route_table.private.*.id, count.index)}"
}
