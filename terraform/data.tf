data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "main" {}

# Launch Configuration User Data
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"
  vars = {
    cluster_name = aws_ecs_cluster.my_cluster.name
    ebs_region   = var.aws_region
  }
}

# ECS Task Definition
data "aws_ecs_task_definition" "my_task_def" {
  task_definition = aws_ecs_task_definition.my-task.family
  depends_on      = [aws_ecs_task_definition.my-task]
}

# Subnet ID 
data "aws_subnet" "selected" {
  count = length(var.subnets)
  id    = element(var.subnets, count.index)
}