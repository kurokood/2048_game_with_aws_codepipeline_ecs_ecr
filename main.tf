# Data sources for AWS account information
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Get default VPC and subnets for ECS
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# IAM Module - Creates all required IAM roles and policies
# Must be created first as other modules depend on the roles
module "iam" {
  source = "./modules/iam"

  project_name            = var.project_name
  account_id              = data.aws_caller_identity.current.account_id
  region                  = data.aws_region.current.name
  s3_artifact_bucket_name = var.s3_artifact_bucket_name
  ecr_repository_name     = var.ecr_repository_name
  ecs_cluster_name           = var.ecs_cluster_name
  ecs_service_name           = var.ecs_service_name
  ecs_task_definition_name   = var.ecs_task_definition_name
  codebuild_project_name     = var.codebuild_project_name
}

# ECR Module - Creates container registry
# Can be created in parallel with S3, depends on IAM for permissions
module "ecr" {
  source = "./modules/ecr"

  depends_on = [module.iam]

  repository_name = var.ecr_repository_name
  project_name    = var.project_name
  environment     = var.environment
}

# S3 Module - Creates artifacts bucket
# Can be created in parallel with ECR, depends on IAM for permissions
module "s3" {
  source = "./modules/s3"

  depends_on = [module.iam]

  bucket_name  = var.s3_artifact_bucket_name
  project_name = var.project_name
  environment  = var.environment
}

# ECS Module - Creates Fargate infrastructure
# Depends on IAM for roles and ECR for container image repository
module "ecs" {
  source = "./modules/ecs"

  depends_on = [module.iam, module.ecr]

  project_name            = var.project_name
  environment             = var.environment
  aws_region              = data.aws_region.current.name
  cluster_name            = var.ecs_cluster_name
  task_definition_name    = var.ecs_task_definition_name
  container_name          = var.ecs_container_name
  service_name            = var.ecs_service_name
  ecr_repository_url      = module.ecr.repository_url
  desired_count           = var.desired_task_count
  container_port          = var.container_port
  task_cpu                = tostring(var.cpu)
  task_memory             = tostring(var.memory)
  vpc_id                  = data.aws_vpc.default.id
  subnet_ids              = data.aws_subnets.default.ids
  task_execution_role_arn = module.iam.ecs_service_role_arn
  task_role_arn           = module.iam.ecs_service_role_arn
}

# CodeBuild Module - Creates build project
# Depends on IAM for roles, ECR for image repository, and S3 for artifacts
module "codebuild" {
  source = "./modules/codebuild"

  depends_on = [module.iam, module.ecr, module.s3]

  project_name        = var.codebuild_project_name
  service_role_arn    = module.iam.codebuild_service_role_arn
  s3_bucket_name      = var.s3_artifact_bucket_name
  ecr_repository_name = var.ecr_repository_name
  account_id          = data.aws_caller_identity.current.account_id
  region              = data.aws_region.current.name
  environment         = var.environment
  container_name      = var.ecs_container_name
}

# CodePipeline Module - Creates CI/CD pipeline
# Depends on all other modules as it orchestrates the entire pipeline
module "codepipeline" {
  source = "./modules/codepipeline"

  depends_on = [module.iam, module.s3, module.codebuild, module.ecs]

  pipeline_name          = var.codepipeline_name
  service_role_arn       = module.iam.codepipeline_service_role_arn
  s3_bucket_name         = var.s3_artifact_bucket_name
  github_owner           = var.github_owner
  github_repo            = var.github_repo
  github_branch          = var.github_branch
  github_token           = var.github_token
  codebuild_project_name = var.codebuild_project_name
  ecs_cluster_name       = var.ecs_cluster_name
  ecs_service_name       = var.ecs_service_name
}
