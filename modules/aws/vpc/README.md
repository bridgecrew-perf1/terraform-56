Example of a environment specific stack
```
provider "aws" {
  region                          = ""
  version                         = "~> 1.37"
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

terraform {
  backend "s3" {
    bucket                        = ""
    key                           = ""
    region                        = ""
    dynamodb_table                = ""
  }
}

module "root<NAME>" {
  source = "git::https://github.com/terraform//modules//aws//vpc//default?ref=<VERSION>"
  # source = "<LOCAL_PATH_FOR_DEV>"
  env                             = ""
  account                         = ""
  region                          = ""
  tagpro                          = ""
  tagown                          = ""
  vpc_name                        = ""
  cidr                            = "10.1.0.0/16"
  dhcp_domain_name                = ""
  azs                             = []
  public_subnets                  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  private_subnets                 = ["10.1.110.0/24", "10.1.120.0/24", "10.1.130.0/24"]
  app_subnets                     = []
  rs_subnets                      = []
  rds_subnets                     = []
  # eip                             = []
}
```


Example of a base stack
```
module "vpc_main" {
  source = "<YOUR_REPO_PATH_AND_VERSION>"
  # source = "<LOCAL_PATH_FOR_DEV>"
  name                                = "${var.vpc_name}"
  cidr                                = "${var.cidr}"
  vpc_tenancy                         = "default"
  enable_dns_support                  = true
  enable_dns_hostnames                = true
  dhcp_domain_name                    = "${var.dhcp_domain_name}"
  domain_name_servers                 = ["AmazonProvidedDNS"]
  # dhcp_dns_ntp_servers                = ""
  enable_dhcp                         = true
  azs                                 = ["${var.azs}"]
  public_subnets                      = ["${var.public_subnets}"]
  private_subnets                     = ["${var.private_subnets}"]
  rds_subnets                         = ["${var.rds_subnets}"]
  app_subnets                         = ["${var.app_subnets}"]
  # eip                                 = ["${var.eip}"]
  map_ip                              = true
  tagpro                              = "${var.tagpro}"
  tagapp                              = "${var.vpc_name}"
  tagenv                              = "${var.env}"
  tagown                              = "${var.tagown}"
  tagmod                              = "${data.aws_caller_identity.main.arn}"
}
```