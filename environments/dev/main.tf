
terraform {
  required_version = ">= 1.6.0"
}

module "iam" {
  source      = "../../modules/iam"
  project     = var.project
  environment = var.environment
  tags        = local.tags
}

module "s3_data_lake" {
  source      = "../../modules/s3-data-lake"
  project     = var.project
  environment = var.environment
  tags        = local.tags
}

module "glue_catalog" {
  source         = "../../modules/glue-catalog"
  project        = var.project
  environment    = var.environment
  bronze_prefix  = module.s3_data_lake.bronze_prefix
  silver_prefix  = module.s3_data_lake.silver_prefix
  gold_prefix    = module.s3_data_lake.gold_prefix
  s3_bucket_name = module.s3_data_lake.bucket_name
  glue_role_arn  = module.iam.glue_role_arn
  tags           = local.tags
  depends_on     = [module.s3_data_lake, module.iam]
}

module "glue_jobs" {
  source            = "../../modules/glue-jobs"
  project           = var.project
  environment       = var.environment
  glue_role_arn     = module.iam.glue_role_arn
  script_s3_path    = module.s3_data_lake.script_prefix
  bronze_prefix     = module.s3_data_lake.bronze_prefix
  silver_prefix     = module.s3_data_lake.silver_prefix
  gold_prefix       = module.s3_data_lake.gold_prefix
  glue_version      = "5.0"
  worker_type       = "G.1X"
  number_of_workers = 5
  tags              = local.tags
  depends_on        = [module.glue_catalog]
}

module "athena" {
  source           = "../../modules/athena"
  project          = var.project
  environment      = var.environment
  query_results_s3 = module.s3_data_lake.athena_results_prefix
  glue_database    = module.glue_catalog.database_name
  tags             = local.tags
}

# Optional orchestration via EventBridge/Lambda or Step Functions
module "eventbridge" {
  source             = "../../modules/eventbridge"
  project            = var.project
  environment        = var.environment
  bronze_job_name    = module.glue_jobs.bronze_to_silver_job_name
  silver_job_name    = module.glue_jobs.silver_to_gold_job_name
  tags               = local.tags
  depends_on         = [module.glue_jobs]
}
