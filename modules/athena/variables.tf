variable "project" { type = string }
variable "environment" { type = string }
variable "query_results_s3" { type = string }
variable "glue_database" { type = string }
variable "tags" { type = map(string) }