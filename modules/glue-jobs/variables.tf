locals {
  glue_scripts_path = "${path.module}/scripts/"
}
variable "project" { type = string }
variable "environment" { type = string }
variable "glue_role_arn" { type = string }
variable "s3_data_lake" { type = string }
variable "scripts_prefix" { type = string }
variable "bronze_prefix" { type = string }
variable "silver_prefix" { type = string }
variable "gold_prefix" { type = string }
variable "glue_version" { type = string }
variable "worker_type" { type = string }
variable "number_of_workers" { type = number }
variable "tags" { type = map(string) }


