variable "pipeline_name" {
  description = "Name of the CodePipeline"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.pipeline_name))
    error_message = "CodePipeline name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "service_role_arn" {
  description = "ARN of the CodePipeline service role"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.service_role_arn))
    error_message = "Service role ARN must be a valid IAM role ARN."
  }
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing pipeline artifacts"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.s3_bucket_name)) && length(var.s3_bucket_name) >= 3 && length(var.s3_bucket_name) <= 63
    error_message = "S3 bucket name must be between 3 and 63 characters, contain only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "github_owner" {
  description = "GitHub repository owner/organization name"
  type        = string

  validation {
    condition     = length(var.github_owner) > 0
    error_message = "GitHub owner cannot be empty."
  }
}

variable "github_repo" {
  description = "GitHub repository name without the owner prefix"
  type        = string

  validation {
    condition     = length(var.github_repo) > 0
    error_message = "GitHub repository name cannot be empty."
  }
}

variable "github_branch" {
  description = "GitHub branch to use for the pipeline source stage"
  type        = string

  validation {
    condition     = length(var.github_branch) > 0
    error_message = "GitHub branch cannot be empty."
  }
}

variable "github_token" {
  description = "GitHub personal access token for repository access"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_token) > 0
    error_message = "GitHub token cannot be empty."
  }
}

variable "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.codebuild_project_name))
    error_message = "CodeBuild project name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster for deployment"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.ecs_cluster_name))
    error_message = "ECS cluster name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ecs_service_name" {
  description = "Name of the ECS service for deployment"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.ecs_service_name))
    error_message = "ECS service name must contain only alphanumeric characters, hyphens, and underscores."
  }
}