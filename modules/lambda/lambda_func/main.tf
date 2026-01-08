resource "aws_lambda_function" "unzip_to_bronze" {
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_unzip_to_bronze.lambda_handler"
  runtime       = "python3.13"
  filename      = data.archive_file.lambda_zip.output_path
  timeout       = 60
  memory_size   = 512

  environment {
    variables = {
      BRONZE_PREFIX  = module.s3_data_lake.bronze_prefix
      LANDING_PREFIX = module.s3_data_lake.landing_prefix
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic_logs, aws_iam_role_policy_attachment.lambda_s3_attach]
}

# ----- Lambda function -----

# ----- S3 -> Lambda invoke permission -----
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.unzip_to_bronze.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.lake.bucket}"
}

# ----- S3 bucket notification on landing prefix -----
resource "aws_s3_bucket_notification" "landing_events" {
  bucket = aws_s3_bucket.lake.bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.unzip_to_bronze.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = module.s3_data_lake.landing_prefix
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}
