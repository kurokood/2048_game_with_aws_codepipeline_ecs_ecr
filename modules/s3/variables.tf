variable "bucket_name" {
  description = "Name of the S3 bucket for storing CodePipeline artifacts and build outputs"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "S3 bucket name must be between 3 and 63 characters, contain only lowercase letters, numbers, dots, and hyphens."
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

variable "project_name" {
  description = "Name of the project used for resource tagging"
  type        = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name cannot be empty."
  }
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects (use with caution in production)"
  type        = bool
  default     = true # Set to true for CI/CD artifact buckets
}

