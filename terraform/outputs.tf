output "aws_region" {
  description = "Configured AWS region."
  value       = var.aws_region
}

output "project_name" {
  description = "Project identifier."
  value       = var.project_name
}

output "environment" {
  description = "Configured environment."
  value       = var.environment
}

output "vpc_id" {
  description = "ID of the project VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the project public subnet."
  value       = aws_subnet.public.id
}

output "deployment_security_group_id" {
  description = "ID of the deployment host security group."
  value       = aws_security_group.deployment_host.id
}
