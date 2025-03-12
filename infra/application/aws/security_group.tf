resource "aws_security_group" "hello_spring_boot" {
  name        = "hello spring boot"
  description = "Security group for ECS service, hello spring boot"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "ecs-security-group"
  }
}