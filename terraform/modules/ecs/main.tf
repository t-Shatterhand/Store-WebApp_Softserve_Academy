resource "aws_ecs_cluster" "cluster" {
  name = "${var.app_name}-${var.env}-cluster"
  tags = merge(var.tags, { "Name" = "demo-3-cluster" })
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.app_name}-${var.env}-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_iam_role.arn
  container_definitions = jsonencode([
    {
      name : "${var.app_name}-${var.env}-app"
      image : local.app_image
      cpu : 512,
      memory : 1024,
      networkMode : "awsvpc",
      portMappings : [
        {
          containerPort : var.app_port,
          hostPort : var.app_port
        }
      ]
      environment : [
        {
          name : "DB_HOST",
          value : var.db_host
        },
        {
          "name" : "DB_USER",
          "value" : var.db_user
        },
        {
          name : "DB_PASS",
          value : var.db_password
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "${var.app_name}-${var.env}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    security_groups  = [aws_security_group.ecs_service_sg.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.lb_target_group
    container_name   = "${var.app_name}-${var.env}-app"
    container_port   = var.app_port
  }
}
