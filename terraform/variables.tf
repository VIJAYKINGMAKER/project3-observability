variable "aws_region" {
  description = "AWS region for the infrastructure deployment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name used to identify this project."
  type        = string
  default     = "project3-observability"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR range for the project VPC."
  type        = string
  default     = "10.30.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet."
  type        = string
  default     = "10.30.1.0/24"
}

variable "ecr_repository_arn" {
  description = "ARN of the existing ECR repository the EC2 host may pull images from."
  type        = string
  default     = null
  nullable    = true
}
