# ECR Repo with lifecycle rule

```hcl-terraform
module "example_repo" {
  # source = "local_path"
  source = "git..."
  name = "exampler_repo"
  policy = "${file("./policies/default.json")}"
  lifecycle = "${file("./lifecycle/default.json")}"
}
```