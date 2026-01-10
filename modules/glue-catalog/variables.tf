variable "project" { type = string }
variable "environment" { type = string }
variable "s3_bucket_name" { type = string }
variable "bronze_prefix" { type = string }
variable "silver_prefix" { type = string }
variable "gold_prefix" { type = string }
variable "glue_role_arn" { type = string }
variable "tags" { type = map(string) }