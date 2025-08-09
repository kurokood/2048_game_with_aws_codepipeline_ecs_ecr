variable "repository_name" {
  description = "Name of the ECR repository for storing Docker images"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-_/]+$", var.repository_name))
    error_message = "ECR repository name must contain only lowercase letters, numbers, hyphens, underscores, and forward slashes."
  }
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Image tag mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned for vulnerabilities after being pushed to the repository"
  type        = bool
  default     = true
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
  description = "Name of the project used for resource tagging and naming"
  type        = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name cannot be empty."
  }
}