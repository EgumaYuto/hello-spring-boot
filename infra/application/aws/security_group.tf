# ALB: accepts HTTP from the internet.
resource "aws_security_group" "alb" {
  name        = "${var.app_name}-alb"
  description = "Security group for the ${var.app_name} ALB"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.app_name}-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from the internet"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# ECS tasks: only reachable from the ALB on the container port.
resource "aws_security_group" "ecs" {
  name        = "${var.app_name}-ecs"
  description = "Security group for the ${var.app_name} ECS service"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.app_name}-ecs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  description                  = "Container port from the ALB"
  ip_protocol                  = "tcp"
  from_port                    = var.container_port
  to_port                      = var.container_port
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_all" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow all outbound (ECR, Secrets Manager, Aurora)"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

# Aurora: only reachable from the ECS tasks on the MySQL port.
resource "aws_security_group" "aurora" {
  name        = "${var.app_name}-aurora"
  description = "Security group for the ${var.app_name} Aurora cluster"
  vpc_id      = local.vpc_id

  tags = {
    Name = "${var.app_name}-aurora"
  }
}

resource "aws_vpc_security_group_ingress_rule" "aurora_from_ecs" {
  security_group_id            = aws_security_group.aurora.id
  description                  = "MySQL from the ECS service"
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.ecs.id
}

resource "aws_vpc_security_group_egress_rule" "aurora_all" {
  security_group_id = aws_security_group.aurora.id
  description       = "Allow all outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
