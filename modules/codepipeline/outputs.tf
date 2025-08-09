output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.game_pipeline.name
}

output "pipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.game_pipeline.arn
}

output "pipeline_id" {
  description = "ID of the CodePipeline"
  value       = aws_codepipeline.game_pipeline.id
}