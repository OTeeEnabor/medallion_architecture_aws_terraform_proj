
variable "project"     { type = string }
variable "environment" { type = string }
variable "aws_region"  { type = string }

locals {
  tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}
