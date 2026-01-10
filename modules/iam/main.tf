
resource "aws_iam_policy" "data_lake_access_policy" {
  name        = "S3DataLakePolicy-${var.s3_data_lake}"
  description = "This policy allows for running glue jobs in the glue console and access data lake."
  policy      = data.aws_iam_policy_document.data_lake_policy.json
  tags        = var.tags
}

resource "aws_iam_policy" "cloudwatch_log_policy" {
  name = "CloudWatchPolicy-${var.project}"
  description = "This policy allows for glue to create logs in CloudWatch"
  policy = data.aws_iam_policy_document.glue_cloud_watch_logs.json
  tags = var.tags
}

resource "aws_iam_policy" "catalog_policy" {
  name = "GlueCataLogPolicy-${var.project}"
  description = "This policy allows for glue perform actions in glue catalog."
  policy = data.aws_iam_policy_document.glue_db_policy.json
  tags = var.tags
}
resource "aws_iam_role" "glue_role" {
  name               = "${var.project}-${var.environment}-glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "data_lake_permissions" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.data_lake_access_policy.arn
}

# cloudwatch
resource "aws_iam_role_policy_attachment" "log_policy"{
  role = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.cloudwatch_log_policy.arn
}

# glue-catalog permissions
resource "aws_iam_role_policy_attachment" "glue_catalog_policy" {
  role = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.catalog_policy.arn
}

resource "aws_iam_policy" "lambda_s3_policy" {
  name   = "${var.project}-bronze-lambda-s3-policy"
  policy = data.aws_iam_policy_document.lambda_s3_policy.json
  tags   = var.tags
}
resource "aws_iam_role" "lambda_role" {
  name               = "${var.project}-${var.environment}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda-role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn

}

output "glue_role_arn" { value = aws_iam_role.glue_role.arn }
output "lambda_role_arn" { value = aws_iam_role.lambda_role.arn }
