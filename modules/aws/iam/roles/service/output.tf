output "role_arn" {
  value = aws_iam_role.main.arn
}

output "role_name" {
  value = aws_iam_role.main.name
}

output "instance_arn" {
  value = aws_iam_instance_profile.main.arn
}

output "instance_unique_id" {
  value = aws_iam_instance_profile.main.unique_id
}

output "instance_name" {
  value = aws_iam_instance_profile.main.name
}

