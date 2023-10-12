# service security group
resource "aws_security_group" "ecs_service_sg" {
  name        = "ECS Service Security Group"
  description = "Allow 9999 access"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = ["9999"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# and iam roles for task def
