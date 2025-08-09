# Project Information
output "project_name" {
  description = "Name of the project"
  value       = var.project_name
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "aws_region" {
  description = "AWS region where resources are deployed"
  value       = data.aws_region.current.name
}

output "aws_account_id" {
  description = "AWS account ID where resources are deployed"
  value       = data.aws_caller_identity.current.account_id
}

# ECR Outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository for Docker image storage"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = module.ecr.repository_arn
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = module.ecr.repository_name
}

output "ecr_registry_id" {
  description = "Registry ID of the ECR repository"
  value       = module.ecr.registry_id
}

# S3 Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket for storing pipeline artifacts"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 artifacts bucket"
  value       = module.s3.bucket_arn
}

output "s3_bucket_id" {
  description = "ID of the S3 artifacts bucket"
  value       = module.s3.bucket_id
}

# ECS Outputs
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.cluster_arn
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.ecs.service_name
}

output "ecs_service_arn" {
  description = "ARN of the ECS service"
  value       = module.ecs.service_arn
}

output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = module.ecs.task_definition_arn
}

output "ecs_task_definition_family" {
  description = "Family of the ECS task definition"
  value       = module.ecs.task_definition_family
}

output "ecs_task_definition_revision" {
  description = "Revision number of the ECS task definition"
  value       = module.ecs.task_definition_revision
}

output "ecs_log_group_name" {
  description = "Name of the CloudWatch log group for ECS tasks"
  value       = module.ecs.log_group_name
}

output "ecs_security_group_id" {
  description = "ID of the security group for ECS tasks"
  value       = module.ecs.security_group_id
}

# CodeBuild Outputs
output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = module.codebuild.project_name
}

output "codebuild_project_arn" {
  description = "ARN of the CodeBuild project"
  value       = module.codebuild.project_arn
}

output "codebuild_project_id" {
  description = "ID of the CodeBuild project"
  value       = module.codebuild.project_id
}

output "codebuild_log_group_name" {
  description = "Name of the CloudWatch log group for CodeBuild"
  value       = module.codebuild.log_group_name
}

output "codebuild_log_group_arn" {
  description = "ARN of the CloudWatch log group for CodeBuild"
  value       = module.codebuild.log_group_arn
}

# CodePipeline Outputs
output "codepipeline_name" {
  description = "Name of the CodePipeline"
  value       = module.codepipeline.pipeline_name
}

output "codepipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = module.codepipeline.pipeline_arn
}

output "codepipeline_id" {
  description = "ID of the CodePipeline"
  value       = module.codepipeline.pipeline_id
}

# IAM Outputs
output "iam_ecs_service_role_arn" {
  description = "ARN of the ECS service role for task execution and management"
  value       = module.iam.ecs_service_role_arn
}

output "iam_codebuild_service_role_arn" {
  description = "ARN of the CodeBuild service role for build operations"
  value       = module.iam.codebuild_service_role_arn
}

output "iam_codepipeline_service_role_arn" {
  description = "ARN of the CodePipeline service role for pipeline orchestration"
  value       = module.iam.codepipeline_service_role_arn
}

# Network Information
output "vpc_id" {
  description = "ID of the VPC where ECS resources are deployed"
  value       = data.aws_vpc.default.id
}

output "subnet_ids" {
  description = "List of subnet IDs where ECS tasks are deployed"
  value       = data.aws_subnets.default.ids
}

# Application Access Information
output "application_info" {
  description = "Information about accessing the deployed application"
  value = {
    cluster_name   = module.ecs.cluster_name
    service_name   = module.ecs.service_name
    container_port = var.container_port
    desired_count  = var.desired_task_count
    cpu            = var.cpu
    memory         = var.memory
  }
}

# CI/CD Pipeline Information
output "pipeline_info" {
  description = "Information about the CI/CD pipeline configuration"
  value = {
    pipeline_name      = module.codepipeline.pipeline_name
    build_project      = module.codebuild.project_name
    source_repo        = var.github_repository_url
    source_branch      = var.github_branch
    artifact_bucket    = module.s3.bucket_name
    container_registry = module.ecr.repository_url
  }
}