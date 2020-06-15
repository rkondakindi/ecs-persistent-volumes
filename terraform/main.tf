resource "aws_cloudwatch_log_group" "log_group" {
  depends_on = [aws_ecs_cluster.my_cluster]
  name = aws_ecs_cluster.my_cluster.name

  retention_in_days = 3
  tags = local.default_tags
}

# ECR
resource "aws_ecr_repository" "foo" {
  count                = var.ecr_repo != "" ? 1 : 0
  name                 = var.ecr_repo
  image_tag_mutability = "MUTABLE"
  # lifecycle {
  #   prevent_destroy = true
  # }
  tags = merge({ Name = var.ecr_repo }, local.default_tags)
}

# ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "${var.stack_name}-${var.cluster_name}-${var.environment}"
  tags = merge({ Name = "${var.cluster_name}-${var.environment}" }, local.default_tags)
}

# ECS Task Definition
resource "aws_ecs_task_definition" "my-task" {
  family                   = "${var.stack_name}-my-task"
  cpu                      = 128
  memory                   = 256
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  volume {
    name = "mydisk"
    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
      driver        = "rexray/ebs"
      driver_opts = {
        volumetype = "gp2"
        size       = 20
      }
    }
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(",", local.availability_zones)}]"
  }
  container_definitions = <<DEFINITION
[{
  "mountPoints": 
  [{
    "sourceVolume": "mydisk",
    "containerPath": "${var.mount_path}",
    "readOnly": false
  }],
  "image": "${local.image}",
  "name": "apache",
  "essential": true,
  "networkMode": "awsvpc",
  "requiresCompatibilities": 
  [
    "EC2"
  ],
  "portMappings": 
  [{
      "containerPort": 80
  }],
  "logConfiguration": 
  {
    "logDriver": "awslogs",
    "options": 
    {
      "awslogs-group": "${aws_ecs_cluster.my_cluster.name}",
      "awslogs-region": "${var.aws_region}",
      "awslogs-stream-prefix": "ecs"
    }
  }
}]
DEFINITION
}

# ECS Service
resource "aws_ecs_service" "my_service" {
  name          = "apache-${var.environment}"
  cluster       = aws_ecs_cluster.my_cluster.id
  desired_count = 2
  depends_on    = [aws_alb_target_group.my_target_group, aws_alb_listener.my_load_balancer_listener]
  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.my-task.family}:${max("${aws_ecs_task_definition.my-task.revision}", "${data.aws_ecs_task_definition.my_task_def.revision}")}"

  load_balancer {
    target_group_arn = aws_alb_target_group.my_target_group.arn
    container_name   = "apache"
    container_port   = 80
  }
  network_configuration {
    subnets         = var.subnets
    security_groups = [var.sec_group]
  }

  #tags = merge({ Name = "apache-${var.environment}" }, local.default_tags)
}