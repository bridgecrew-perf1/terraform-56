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

### Group modules:
The group modules are split into two very similar modules, the main difference is a Terraform limitation, you cannot attach a policy and use policy attachment to attach another managed policy to the group with terraform, thus the separate modules.

##### Example for managed policy
```hcl-terraform
module "group" {
  source = "../terraform/modules/aws/iam/groupManagedPol/"
  group_users = ["${var.Users}"]
  name = "${var.name}"
  path = "/groups/${var.env}/${var.project}/"
  policy_arn = "${var.policy_arn}"
}
```
##### Example for custom managed policy
```hcl-terraform
module "group" {
  source = "../terraform/modules/aws/iam/groupCustomPol/"
  group_users = ["${var.users}"]
  policy = "${data.aws_iam_policy_document.DevTeam2.json}"
  name = "${var.ame}"
  path = "/groups/${var.env}/${var.project}/"
}
```
