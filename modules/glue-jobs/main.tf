resource "aws_s3_object" "test_deploy_script_s3" {
  bucket = var.s3_data_lake
  key    = "${var.scripts_prefix}test/testDeployScript.py"
  source = "${local.glue_scripts_path}testDeployScript.py"
  etag   = filemd5("${local.glue_scripts_path}testDeployScript.py")
}

resource "aws_glue_job" "test_deployment_script" {
  name              = "${var.project}-${var.environment}-test"
  role_arn          = var.glue_role_arn
  glue_version      = var.glue_version
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = "s3://${var.s3_data_lake}/${var.scripts_prefix}testDeployScript.py"
  }

  default_arguments = {
    "--job-language"   = "python"
    "--enable-metrics" = "true"
    "--PROJECT"        = var.project
    "--ENV"            = var.environment
  }

  tags = var.tags
}

resource "aws_glue_job" "bronze_to_silver" {
  name              = "${var.project}-${var.environment}-bronze-to-silver"
  role_arn          = var.glue_role_arn
  glue_version      = var.glue_version
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = "s3://${var.s3_data_lake}/${var.scripts_prefix}bronze_to_silver.py"
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
  name              = "${var.project}-${var.environment}-silver-to-gold"
  role_arn          = var.glue_role_arn
  glue_version      = var.glue_version
  worker_type       = var.worker_type
  number_of_workers = var.number_of_workers

  command {
    name            = "glueetl"
    python_version  = "3"
    script_location = "s3://${var.s3_data_lake}/${var.scripts_prefix}silver_to_gold.py"
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
output "silver_to_gold_job_name" { value = aws_glue_job.silver_to_gold.name }
