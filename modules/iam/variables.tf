variable "state_bucket" { type = string }
variable "project" { type = string }
variable "environment" { type = string }
variable "tags" { type = map(string) }
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
variable "database_name" {
  type        = string
  description = "The name of the glue catalog database."
}

