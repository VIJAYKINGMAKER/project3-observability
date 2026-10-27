resource "aws_security_group" "deployment_host" {
  name        = "${var.project_name}-${var.environment}-deployment-sg"
  description = "No inbound access; administer through Systems Manager"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "Outbound IPv4 traffic for ECR and Systems Manager"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-deployment-sg"
  }
}
