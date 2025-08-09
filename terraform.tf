terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration for state management
  # To use remote state storage, uncomment the backend block below and:
  # 1. Replace "your-terraform-state-bucket" with your actual S3 bucket name
  # 2. Optionally create a DynamoDB table for state locking
  # 3. Run "terraform init" to migrate state to the remote backend
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket" # Replace with your state bucket name
  #   key    = "2048-game-cicd/terraform.tfstate"
  #   region = "us-east-1"
  #
  #   # Optional: Enable state locking with DynamoDB
  #   # dynamodb_table = "terraform-state-lock"
  #   # encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}