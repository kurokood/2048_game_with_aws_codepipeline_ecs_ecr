# Project Configuration
variable "project_name" {
  description = "Name of the project used as a prefix for resource naming"
  type        = string
  default     = "2048-game"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.project_name))
    error_message = "Project name must contain only alphanumeric characters and hyphens."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod) used for resource tagging and naming"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# AWS Configuration
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "AWS region must be a valid region identifier."
  }
}

variable "aws_account_id" {
  description = "AWS account ID where resources will be created"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "AWS account ID must be a 12-digit number."
  }
}

# GitHub Configuration
variable "github_repository_url" {
  description = "GitHub repository URL for the 2048 game source code"
  type        = string
  default     = "https://github.com/kurokood/2048_game_with_aws_codepipeline_ecs_ecr.git"

  validation {
    condition     = can(regex("^https://github\\.com/.+/.+\\.git$", var.github_repository_url))
    error_message = "GitHub repository URL must be a valid HTTPS GitHub URL ending with .git."
  }
}

variable "github_owner" {
  description = "GitHub repository owner/organization name"
  type        = string
  default     = "kurokood"

  validation {
    condition     = length(var.github_owner) > 0
    error_message = "GitHub owner cannot be empty."
  }
}

variable "github_repo" {
  description = "GitHub repository name without the owner prefix"
  type        = string
  default     = "2048_game_with_aws_codepipeline_ecs_ecr"

  validation {
    condition     = length(var.github_repo) > 0
    error_message = "GitHub repository name cannot be empty."
  }
}

variable "github_branch" {
  description = "GitHub branch to use for the CI/CD pipeline source stage"
  type        = string
  default     = "master"

  validation {
    condition     = length(var.github_branch) > 0
    error_message = "GitHub branch cannot be empty."
  }
}

variable "github_token" {
  description = "GitHub personal access token for CodePipeline to access the repository"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.github_token) > 0
    error_message = "GitHub token cannot be empty."
  }
}

# ECR Configuration
variable "ecr_repository_name" {
  description = "Name of the ECR repository for storing Docker images"
  type        = string
  default     = "2048-game-repo"

  validation {
    condition     = can(regex("^[a-z0-9-_/]+$", var.ecr_repository_name))
    error_message = "ECR repository name must contain only lowercase letters, numbers, hyphens, underscores, and forward slashes."
  }
}

# S3 Configuration
variable "s3_artifact_bucket_name" {
  description = "Name of the S3 bucket for storing CodePipeline artifacts and build outputs"
  type        = string
  default     = "2048-game-cicd-pipeline-artifact-121485"

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.s3_artifact_bucket_name)) && length(var.s3_artifact_bucket_name) >= 3 && length(var.s3_artifact_bucket_name) <= 63
    error_message = "S3 bucket name must be between 3 and 63 characters, contain only lowercase letters, numbers, dots, and hyphens."
  }
}

# ECS Configuration
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster for running containerized applications"
  type        = string
  default     = "2048-game-cluster"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.ecs_cluster_name))
    error_message = "ECS cluster name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ecs_service_name" {
  description = "Name of the ECS service for managing task instances"
  type        = string
  default     = "2048-service"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.ecs_service_name))
    error_message = "ECS service name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ecs_task_definition_name" {
  description = "Name of the ECS task definition that defines the container configuration"
  type        = string
  default     = "2048-game-task"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.ecs_task_definition_name))
    error_message = "ECS task definition name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ecs_container_name" {
  description = "Name of the container within the ECS task definition"
  type        = string
  default     = "2048-container"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.ecs_container_name))
    error_message = "Container name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "desired_task_count" {
  description = "Desired number of ECS tasks to run simultaneously"
  type        = number
  default     = 1

  validation {
    condition     = var.desired_task_count >= 0 && var.desired_task_count <= 100
    error_message = "Desired task count must be between 0 and 100."
  }
}

variable "container_port" {
  description = "Port number on which the container application listens for traffic"
  type        = number
  default     = 80

  validation {
    condition     = var.container_port > 0 && var.container_port <= 65535
    error_message = "Container port must be between 1 and 65535."
  }
}

variable "cpu" {
  description = "CPU units for the ECS task (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.cpu)
    error_message = "CPU must be one of: 256, 512, 1024, 2048, 4096."
  }
}

variable "memory" {
  description = "Memory (in MiB) for the ECS task, must be compatible with CPU setting"
  type        = number
  default     = 512

  validation {
    condition     = var.memory >= 512 && var.memory <= 30720
    error_message = "Memory must be between 512 and 30720 MiB."
  }
}

# CodeBuild Configuration
variable "codebuild_project_name" {
  description = "Name of the CodeBuild project for building and pushing Docker images"
  type        = string
  default     = "2048-game-build"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.codebuild_project_name))
    error_message = "CodeBuild project name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

# CodePipeline Configuration
variable "codepipeline_name" {
  description = "Name of the CodePipeline for orchestrating the CI/CD process"
  type        = string
  default     = "2048-game-pipeline"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.codepipeline_name))
    error_message = "CodePipeline name must contain only alphanumeric characters, hyphens, and underscores."
  }
}