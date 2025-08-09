output "ecs_service_role_arn" {
  description = "ARN of the ECS service role"
  value       = aws_iam_role.ecs_service_role.arn
}

output "codebuild_service_role_arn" {
  description = "ARN of the CodeBuild service role"
  value       = aws_iam_role.codebuild_service_role.arn
}

output "codepipeline_service_role_arn" {
  description = "ARN of the CodePipeline service role"
  value       = aws_iam_role.codepipeline_service_role.arn
}