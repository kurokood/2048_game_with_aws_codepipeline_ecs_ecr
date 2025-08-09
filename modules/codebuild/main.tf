# CodeBuild project for building and pushing Docker images
resource "aws_codebuild_project" "game_build" {
  name         = var.project_name
  description  = "CodeBuild project for building and pushing 2048 game Docker images"
  service_role = var.service_role_arn

  artifacts {
    type      = "S3"
    location  = "${var.s3_bucket_name}/build-artifacts"
    packaging = "NONE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = var.ecr_repository_name
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name  = "CONTAINER_NAME"
      value = var.container_name
    }
  }

  source {
    type            = "GITHUB"
    location        = var.github_repository_url
    git_clone_depth = 1

    buildspec = "buildspec.yml"
  }

  tags = {
    Name        = var.project_name
    Environment = var.environment
  }
}

# CloudWatch Log Group for CodeBuild logs
resource "aws_cloudwatch_log_group" "codebuild_logs" {
  name              = "/aws/codebuild/${var.project_name}"
  retention_in_days = 14

  tags = {
    Name        = "${var.project_name}-logs"
    Environment = var.environment
  }
}