# ----- Package Lambda code locally -----
# Assumes lambda_unzip_to_bronze.py is in ./lambda_func/scripts/
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/scripts/"
  output_path = "${path.module}/build/unzip_to_bronze.zip"
}