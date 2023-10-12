resource "aws_ecs_cluster" "cluster" {
  name = "${var.app_name}-${var.env}-cluster"
  tags = merge(var.tags, { "Name" = "demo-3-cluster" })
}

data "template_file" "app" {
  template = file(var.taskdef_template)

  vars = {
    app_name  = var.app_name
    env       = var.env
    app_port  = var.app_port
    image_tag = var.image_tag
    app_image = local.app_image
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.app_name}-${var.env}-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_iam_role.arn
  container_definitions    = data.template_file.app.rendered
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
