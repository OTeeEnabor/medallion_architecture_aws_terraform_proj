data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
# glue service role
data "aws_iam_policy_document" "glue_role" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

# policy to have access to s3 datalake
data "aws_iam_policy_document" "data_lake_policy" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.state_bucket}/*", "${var.s3_data_lake_arn}/*"]
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
  }

  statement {
    effect = "Allow"
    resources = ["arn:aws:s3:::${var.state_bucket}",
      "${var.s3_data_lake_arn}"
    ]
    actions = ["s3:ListBucket"]
  }
}

# glue CloudWatch logs

data "aws_iam_policy_document" "glue_cloud_watch_logs" {
    statement {
      sid = "logs"

      effect = "Allow"
      actions = [ "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents",
        "logs:DescribeLogStreams" ]
        resources = [
            "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/jobs:*",
            "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws-glue/crawlers:*"
        ] 
    }
}

data "aws_iam_policy_document" "lambda-role" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "lambda_s3_policy" {
  statement {
    sid     = "ReadLanding"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = ["${var.s3_data_lake_arn}",
    "${var.s3_data_lake_arn}/${var.s3_data_lake_bronze_prefix}/*"]

  }
  statement {
    sid     = "WhiteBronze"
    effect  = "Allow"
    actions = ["s3:PutObject", "s3:AbortMultipartUpload"]
    resources = [
    "${var.s3_data_lake_arn}/${var.s3_data_lake_bronze_prefix}/*"]
  }
}

# glue 
data "aws_iam_policy_document" "glue_db_policy" {

    statement {
        sid = ""
        effect = "Allow"
        actions = [
            "glue:GetDatabase",
            "glue:GetTable",
            "glue:CreateTable",
            "glue:UpdateTable"
        ]
        resources = [
            "arn:aws:glue:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:catalog",
            "arn:aws:glue:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:database/${var.database_name}",
            "arn:aws:glue:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:table/${var.database_name}/*"
        ]
    }
}

