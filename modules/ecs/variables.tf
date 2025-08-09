variable "project_name" {
  description = "Name of the project used for resource naming and tagging"
  type        = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name cannot be empty."
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

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.cluster_name))
    error_message = "ECS cluster name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "task_definition_name" {
  description = "Name of the ECS task definition"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.task_definition_name))
    error_message = "ECS task definition name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "container_name" {
  description = "Name of the container within the task definition"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.container_name))
    error_message = "Container name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "ecr_repository_url" {
  description = "ECR repository URL for the container image"
  type        = string

  validation {
    condition     = can(regex("^[0-9]+\\.dkr\\.ecr\\.[a-z0-9-]+\\.amazonaws\\.com/.+$", var.ecr_repository_url))
    error_message = "ECR repository URL must be a valid ECR repository URL format."
  }
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory for the task"
  type        = string
  default     = "512"
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "task_execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID where ECS service will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign public IP to ECS tasks"
  type        = bool
  default     = true
}