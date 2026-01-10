variable "bucket_name" { type = string }

variable "lambda_name" {
  type    = string
  default = "unzip-to-bronze"
}

variable "lambda_role_arn" {
  type        = string
  description = "The ARN of the lambda role used for this project."
}

variable "s3_data_lake" {
  type        = string
  description = "The data_lake_bucket name from the s3_data_lake_module"
}

variable "s3_data_lake_arn" {
  type        = string
  description = "The data_lake_bucket arn from the s3_data_lake_module"
}

variable "s3_data_lake_bronze_prefix" {
  type        = string
  description = "The data_lake_bucket arn from the s3_data_lake_module"
}

variable "s3_data_lake_landing_prefix" {
  type        = string
  description = "The data_lake_bucket arn from the s3_data_lake_module"
}
