
variable "project" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "state_bucket" { type = string }
locals {
  database_name = "${var.project}_${var.environment}_db"
  tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}
