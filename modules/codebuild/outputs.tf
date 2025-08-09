# CodeBuild module outputs

output "project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.game_build.name
}

output "project_arn" {
  description = "ARN of the CodeBuild project"
  value       = aws_codebuild_project.game_build.arn
}

output "project_id" {
  description = "ID of the CodeBuild project"
  value       = aws_codebuild_project.game_build.id
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.codebuild_logs.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.codebuild_logs.arn
}