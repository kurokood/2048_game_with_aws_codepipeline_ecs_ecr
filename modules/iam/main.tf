# ServiceRoleForECS - IAM role for ECS service
resource "aws_iam_role" "ecs_service_role" {
  name = "${var.project_name}-ServiceRoleForECS"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "${var.project_name}-ServiceRoleForECS"
    Project = var.project_name
  }
}

# Attach AmazonEC2ContainerServiceRole managed policy to ECS service role
resource "aws_iam_role_policy_attachment" "ecs_service_role_policy" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# ECS Task Execution Role - Required for Fargate tasks
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-ECSTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "${var.project_name}-ECSTaskExecutionRole"
    Project = var.project_name
  }
}

# Attach the AWS managed ECS task execution role policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ServiceRoleForCodeBuild - IAM role for CodeBuild service
resource "aws_iam_role" "codebuild_service_role" {
  name = "${var.project_name}-ServiceRoleForCodeBuild"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "${var.project_name}-ServiceRoleForCodeBuild"
    Project = var.project_name
  }
}

# Attach managed policies to CodeBuild service role
resource "aws_iam_role_policy_attachment" "codebuild_ecr_policy" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_s3_policy" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_developer_policy" {
  role       = aws_iam_role.codebuild_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

# Inline policy for CodeBuild - CloudWatch Logs, S3, and CodeBuild permissions
resource "aws_iam_role_policy" "codebuild_service_permission_policy" {
  name = "ServicePermissionPolicyForCodebuild"
  role = aws_iam_role.codebuild_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${var.s3_artifact_bucket_name}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
        Resource = "arn:aws:codebuild:${var.region}:${var.account_id}:report-group/${var.codebuild_project_name}-*"
      }
    ]
  })
}

# Inline policy for CodeBuild - ECS service update permissions
resource "aws_iam_role_policy" "codebuild_ecs_permission_policy" {
  name = "ServicePermissionPolicyForECS"
  role = aws_iam_role.codebuild_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService"
        ]
        Resource = "arn:aws:ecs:${var.region}:${var.account_id}:service/${var.ecs_cluster_name}/${var.ecs_service_name}"
      }
    ]
  })
}
# ServiceRoleForCodePipeline - IAM role for CodePipeline service
resource "aws_iam_role" "codepipeline_service_role" {
  name = "${var.project_name}-ServiceRoleForCodePipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "${var.project_name}-ServiceRoleForCodePipeline"
    Project = var.project_name
  }
}

# Attach AWS managed policy for ECS full access to CodePipeline role
resource "aws_iam_role_policy_attachment" "codepipeline_ecs_full_access" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

# Additional policy specifically for CodePipeline ECS deployments
resource "aws_iam_role_policy" "codepipeline_ecs_deployment_policy" {
  name = "CodePipelineECSDeploymentPolicy"
  role = aws_iam_role.codepipeline_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "ecs:ListTasks",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "ecs:DescribeClusters"
        ]
        Resource = [
          "arn:aws:ecs:${var.region}:${var.account_id}:cluster/${var.ecs_cluster_name}",
          "arn:aws:ecs:${var.region}:${var.account_id}:service/${var.ecs_cluster_name}/${var.ecs_service_name}",
          "arn:aws:ecs:${var.region}:${var.account_id}:task-definition/${var.ecs_task_definition_name}:*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:RegisterTaskDefinition",
          "ecs:ListTaskDefinitions",
          "ecs:DescribeTaskDefinition"
        ]
        Resource = "*"
      }
    ]
  })
}

# Inline policy for CodePipeline - S3 bucket access permissions
resource "aws_iam_role_policy" "codepipeline_s3_permission_policy" {
  name = "ServicePermissionPolicyForS3"
  role = aws_iam_role.codepipeline_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketVersioning",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_artifact_bucket_name}",
          "arn:aws:s3:::${var.s3_artifact_bucket_name}/*"
        ]
      }
    ]
  })
}

# Inline policy for CodePipeline - CodeBuild project permissions
resource "aws_iam_role_policy" "codepipeline_codebuild_permission_policy" {
  name = "ServicePermissionPolicyForCodeBuild"
  role = aws_iam_role.codepipeline_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        Resource = "arn:aws:codebuild:${var.region}:${var.account_id}:project/${var.codebuild_project_name}"
      }
    ]
  })
}

# Inline policy for CodePipeline - ECS task definition and service permissions
resource "aws_iam_role_policy" "codepipeline_ecs_permission_policy" {
  name = "ServicePermissionPolicyForECS"
  role = aws_iam_role.codepipeline_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecs:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "application-autoscaling:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      }
    ]
  })
}