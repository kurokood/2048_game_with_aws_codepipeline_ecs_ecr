# CodeBuild module variables

variable "project_name" {
  description = "Name of the CodeBuild project"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.project_name))
    error_message = "CodeBuild project name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "github_repository_url" {
  description = "GitHub repository URL for source code"
  type        = string

  validation {
    condition     = can(regex("^https://github\\.com/.+/.+\\.git$", var.github_repository_url))
    error_message = "GitHub repository URL must be a valid HTTPS GitHub URL ending with .git."
  }
}

variable "service_role_arn" {
  description = "ARN of the IAM service role for CodeBuild"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.service_role_arn))
    error_message = "Service role ARN must be a valid IAM role ARN."
  }
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing build artifacts"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.s3_bucket_name)) && length(var.s3_bucket_name) >= 3 && length(var.s3_bucket_name) <= 63
    error_message = "S3 bucket name must be between 3 and 63 characters, contain only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-_/]+$", var.ecr_repository_name))
    error_message = "ECR repository name must contain only lowercase letters, numbers, hyphens, underscores, and forward slashes."
  }
}

variable "account_id" {
  description = "AWS account ID"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "AWS account ID must be a 12-digit number."
  }
}

variable "region" {
  description = "AWS region"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.region))
    error_message = "AWS region must be a valid region identifier."
  }
}

variable "environment" {
  description = "Environment name used for resource tagging"
  type        = string

  validation {
    condition     = length(var.environment) > 0
    error_message = "Environment cannot be empty."
  }
}

variable "container_name" {
  description = "Name of the container for ECS deployment"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.container_name))
    error_message = "Container name must contain only alphanumeric characters, hyphens, and underscores."
  }
}