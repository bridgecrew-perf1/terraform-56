resource "aws_ecr_repository" "main" {
  name = "${var.name}"
  tags = {
    Name = "${var.name}"
    Project = "${var.tag_project}"
    Environment = "${var.env}"
    awsCostCenter = "${var.tag_costcenter}"
    ModifiedBy = "${var.tag_modifiedby}"
  }
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = "${aws_ecr_repository.main.name}"
  policy = "${var.lifecycle}"
}

resource "aws_ecr_repository_policy" "main" {
  repository = "${aws_ecr_repository.main.name}"
  policy = "${var.policy}"
}
