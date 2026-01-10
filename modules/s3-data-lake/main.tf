
# create s3 data-lake
resource "aws_s3_bucket" "lake" {
  bucket        = "${var.project}-${var.environment}-lake"
  force_destroy = false
  tags          = var.tags
}

# enable versioning for s3 data-lake
resource "aws_s3_bucket_versioning" "versioning" {
  # set bucket to be versioned
  bucket = aws_s3_bucket.lake.id
  versioning_configuration { status = "Enabled" }
}

# enable server side encryption for s3 data-lake
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.lake.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# upload bronze data to s3
resource "aws_s3_object" "bronze_data" {
  bucket       = aws_s3_bucket.lake.bucket
  key          = "bronze/"
  source       = "${local.data_path}"
  etag         = filemd5("${local.data_path}")
  content_type = "text/csv"
}
locals {
  landing_prefix = "landing/"
  bronze_prefix  = "bronze/"
  silver_prefix  = "silver/"
  gold_prefix    = "gold/"
  scripts_prefix = "scripts/"
  athena_prefix  = "athena-results/"
}

output "bucket_name" { value = aws_s3_bucket.lake.bucket }
output "bucket_arn" { value = aws_s3_bucket.lake.arn }
output "landing_prefix" { value = local.landing_prefix }
output "bronze_prefix" { value = local.bronze_prefix }
output "silver_prefix" { value = local.silver_prefix }
output "gold_prefix" { value = local.gold_prefix }
output "script_prefix" { value = local.scripts_prefix }
output "athena_results_prefix" { value = local.athena_prefix }
