
variable "project"     { type = string }
variable "environment" { type = string }
variable "tags"        { type = map(string) }

resource "aws_s3_bucket" "lake" {
  bucket        = "${var.project}-${var.environment}-lake"
  force_destroy = false
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lake.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.lake.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

locals {
  bronze_prefix  = "bronze/"
  silver_prefix  = "silver/"
  gold_prefix    = "gold/"
  scripts_prefix = "scripts/"
  athena_prefix  = "athena-results/"
}

output "bucket_name"             { value = aws_s3_bucket.lake.bucket }
output "bronze_prefix"           { value = local.bronze_prefix }
output "silver_prefix"           { value = local.silver_prefix }
output "gold_prefix"             { value = local.gold_prefix }
output "script_prefix"           { value = local.scripts_prefix }
output "athena_results_prefix"   { value = local.athena_prefix }
