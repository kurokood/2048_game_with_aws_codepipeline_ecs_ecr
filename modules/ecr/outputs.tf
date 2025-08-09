output "repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.game_repo.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository"
  value       = aws_ecr_repository.game_repo.arn
}

output "repository_name" {
  description = "The name of the ECR repository"
  value       = aws_ecr_repository.game_repo.name
}

output "registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.game_repo.registry_id
}