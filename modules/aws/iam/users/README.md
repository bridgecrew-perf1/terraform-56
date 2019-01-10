# IAM module to add multiple users

Although andy this module has a challenge how you manage removing/adding users, use only for demo advised.

Example for single user:
Use the sed_caller_identity data source.
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

Example with multiple users:
Use the sed_caller_identity data source.
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