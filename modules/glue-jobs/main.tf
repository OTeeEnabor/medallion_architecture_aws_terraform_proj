
variable "project"           { type = string }
variable "environment"       { type = string }
variable "glue_role_arn"     { type = string }
variable "script_s3_path"    { type = string }
variable "bronze_prefix"     { type = string }
variable "silver_prefix"     { type = string }
variable "gold_prefix"       { type = string }
variable "glue_version"      { type = string }
variable "worker_type"       { type = string }
variable "number_of_workers" { type = number }
variable "tags"              { type = map(string) }

resource "aws_glue_job" "bronze_to_silver" {
  name         = "${var.project}-${var.environment}-bronze-to-silver"
  role_arn     = var.glue_role_arn
  glue_version = var.glue_version
  worker_type  = var.worker_type
  number_of_workers = var.number_of_workers

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = "${var.script_s3_path}bronze_to_silver.py"
  }

  default_arguments = {
    "--job-language"   = "python"
    "--enable-metrics" = "true"
    "--BRONZE_PREFIX"  = var.bronze_prefix
    "--SILVER_PREFIX"  = var.silver_prefix
    "--PROJECT"        = var.project
    "--ENV"            = var.environment
  }

  tags = var.tags
}

resource "aws_glue_job" "silver_to_gold" {
  name         = "${var.project}-${var.environment}-silver-to-gold"
  role_arn     = var.glue_role_arn
  glue_version = var.glue_version
  worker_type  = var.worker_type
  number_of_workers = var.number_of_workers

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = "${var.script_s3_path}silver_to_gold.py"
  }

  default_arguments = {
    "--job-language"   = "python"
    "--enable-metrics" = "true"
    "--SILVER_PREFIX"  = var.silver_prefix
    "--GOLD_PREFIX"    = var.gold_prefix
    "--PROJECT"        = var.project
    "--ENV"            = var.environment
  }

  tags = var.tags
}

output "bronze_to_silver_job_name" { value = aws_glue_job.bronze_to_silver.name }
output "silver_to_gold_job_name"   { value = aws_glue_job.silver_to_gold.name }
