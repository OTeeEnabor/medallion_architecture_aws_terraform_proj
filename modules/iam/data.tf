

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
    resources = ["arn:aws:s3:::${var.state_bucket}/*"]
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
  }

  statement {
    effect = "Allow"
    resources = ["arn:aws:s3:::${var.state_bucket}/*",
      "${var.s3_data_lake_arn}/*"
    ]
    actions = ["s3:ListBucket"]
  }

  statement {
    effect = "Allow"
    resources = [
      "${var.s3_data_lake_arn}/*"
    ]
    actions = ["s3:GetObject"]
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

