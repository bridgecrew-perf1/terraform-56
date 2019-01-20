# IAM modules


Example for single user:
Use the aws_caller_identity data source.
```hcl-terraform
data "aws_caller_identity" "current" {
  provider = "aws.current"
}
```
The module itself:
```hcl-terraform
module "user" {
  source = "git::https://github.com/boldlink/terraform.git//modules//aws/iam/user/"
  name = "${var.user}"
  tag_costcenter = "${var.costcenter}"
  tag_createdby = "${data.aws_caller_identity.current.arn}"
  tag_env = "${var.env}"
  tag_project = "${var.project}"
}
```
Although andy this module has a challenge how you manage removing/adding users, use only for demo advised.

Use the aws_caller_identity data source.
```hcl-terraform
module "users" {

  source = "git::https://github.com/boldlink/terraform.git//modules//aws/iam/users/"
  users = ["${var.users}"]
  tag_costcenter = "${var.costcenter}"
  tag_createdby = "${data.aws_caller_identity.current.arn}"
  tag_env = "${var.env}"
  tag_project = "${var.project}"
}
```