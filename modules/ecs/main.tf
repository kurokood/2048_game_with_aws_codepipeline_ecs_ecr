# ECS Cluster
resource "aws_ecs_cluster" "game_cluster" {
  name = var.cluster_name

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
    Project     = var.project_name
  }
}

# ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "game_cluster" {
  cluster_name = aws_ecs_cluster.game_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "game_task" {
  family                   = var.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "${var.ecr_repository_url}:latest"

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_logs.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      essential = true
    }
  ])

  tags = {
    Name        = var.task_definition_name
    Environment = var.environment
    Project     = var.project_name
  }
}

# CloudWatch Log Group for ECS
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "/ecs/${var.project_name}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Security Group for ECS Tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.project_name}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-ecs-tasks-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# ECS Service
resource "aws_ecs_service" "game_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.game_cluster.id
  task_definition = aws_ecs_task_definition.game_task.arn
  desired_count   = var.initial_desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = var.assign_public_ip
  }

  tags = {
    Name        = var.service_name
    Environment = var.environment
    Project     = var.project_name
  }

  # Ignore changes to task_definition and desired_count after initial creation
  # CodePipeline will manage these
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  depends_on = [
    aws_ecs_task_definition.game_task,
    aws_ecs_cluster.game_cluster
  ]
}