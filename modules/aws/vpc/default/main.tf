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
    Name                        = "${var.name}.vpc.${count.index}"
    Project                     = "${var.tagpro}"
    Environment                 = "${var.tagenv}"
    Application                 = "${var.tagapp}"
    Owner                       = "${var.tagapp}"
    LastModifyBy                = "${var.tagmod}"
  }
}

/*
VPC flow logs
*/

resource "aws_flow_log" "test_flow_log" {
  log_group_name = "${aws_cloudwatch_log_group.test_log_group.name}"
  iam_role_arn   = "${aws_iam_role.main.arn}"
  vpc_id         = "${aws_vpc.main.id}"
  traffic_type   = "ALL"
}

resource "aws_cloudwatch_log_group" "test_log_group" {
  name = "/awsvpc/${var.name}"
}


resource "aws_iam_role" "main" {
  name = "${var.name}-vpc-logs-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "sts",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "main" {
  name = "${var.name}-vpc-logs-policy"
  role = "${aws_iam_role.main.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
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
    Name                        = "${var.name}.dhcp.${count.index}"
    Project                     = "${var.tagpro}"
    Environment                 = "${var.tagenv}"
    Application                 = "${var.tagapp}"
    Owner                       = "${var.tagapp}"
    LastModifyBy                = "${var.tagmod}"
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
    Name                        = "${var.name}.ig.${count.index}"
    Project                     = "${var.tagpro}"
    Environment                 = "${var.tagenv}"
    Application                 = "${var.tagapp}"
    Owner                       = "${var.tagapp}"
    LastModifyBy                = "${var.tagmod}"
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
    Name                        = "${var.name}.pub.rt.${count.index}"
    Project                     = "${var.tagpro}"
    Environment                 = "${var.tagenv}"
    Application                 = "${var.tagapp}"
    Owner                       = "${var.tagapp}"
    LastModifyBy                = "${var.tagmod}"
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
    Name                        = "${var.name}.pub.subnet.${count.index}"
    Project                     = "${var.tagpro}"
    Environment                 = "${var.tagenv}"
    Application                 = "${var.tagapp}"
    Owner                       = "${var.tagapp}"
    LastModifyBy                = "${var.tagmod}"
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
    Name                       = "${var.name}.pri.rt.${count.index}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
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
    Name                       = "${var.name}.priv.subnet.${count.index}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
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
    Name                       = "${var.name}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
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
RDS Network
*/
resource "aws_route_table" "rds" {
  count                        = "${length(var.rds_subnets) > 0 ? length(var.rds_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  tags {
    Name                       = "${var.name}.rds.rt.${count.index}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
  }
}

resource "aws_subnet" "rds" {
  count                        = "${length(var.rds_subnets) > 0 ? length(var.rds_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  cidr_block                   = "${element(var.rds_subnets, count.index)}"
  availability_zone            = "${element(var.azs, count.index)}"
  tags {
    Name                       = "${var.name}.rds.subnet.${count.index}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
  }
}

resource "aws_route_table_association" "rds" {
  count                        = "${length(var.rds_subnets)}"
  subnet_id                    = "${element(aws_subnet.rds.*.id, count.index)}"
  route_table_id               = "${element(aws_route_table.rds.*.id, count.index)}"
}

/*
ecs network
*/
resource "aws_route_table" "ecs" {
  count                        = "${length(var.ecs_subnets) > 0 ? length(var.ecs_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  tags {
    Name                       = "${var.name}.ecs.rt.${count.index}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
  }
}

resource "aws_subnet" "ecs" {
  count                        = "${length(var.ecs_subnets) > 0 ? length(var.ecs_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  cidr_block                   = "${element(var.ecs_subnets, count.index)}"
  availability_zone            = "${element(var.azs, count.index)}"
  tags {
    Name                       = "${var.name}.ecs.subnet.${count.index}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
  }
}

resource "aws_route_table_association" "ecs" {
  count                        = "${length(var.ecs_subnets)}"
  subnet_id                    = "${element(aws_subnet.ecs.*.id, count.index)}"
  route_table_id               = "${element(aws_route_table.ecs.*.id, count.index)}"
}

/*
RedShift Network
*/

resource "aws_route_table" "rs" {
  count                        = "${length(var.rs_subnets) > 0 ? length(var.rs_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  tags {
    Name                       = "${var.name}.redshift.rt.${count.index}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
  }
}

resource "aws_subnet" "rs" {
  count                        = "${length(var.rs_subnets) > 0 ? length(var.rs_subnets) : 0}"
  vpc_id                       = "${aws_vpc.main.id}"
  cidr_block                   = "${element(var.rs_subnets, count.index)}"
  availability_zone            = "${element(var.azs, count.index)}"
  tags {
    Name                       = "${var.name}.redshift.subnet.${count.index}"
    Project                    = "${var.tagpro}"
    Environment                = "${var.tagenv}"
    Application                = "${var.tagapp}"
    Owner                      = "${var.tagapp}"
    LastModifyBy               = "${var.tagmod}"
  }
}

resource "aws_route_table_association" "rs" {
  count                        = "${length(var.rs_subnets)}"
  subnet_id                    = "${element(aws_subnet.rs.*.id, count.index)}"
  route_table_id               = "${element(aws_route_table.rs.*.id, count.index)}"
}
