
variable "project"     { type = string }
variable "environment" { type = string }
variable "tags"        { type = map(string) }

resource "aws_iam_role" "glue_role" {
  name = "${var.project}-${var.environment}-glue-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = { Service = "glue.amazonaws.com" }
      Effect = "Allow"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy" "glue_policy" {
  name = "${var.project}-${var.environment}-glue-policy"
  role = aws_iam_role.glue_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "S3Access",
        Effect = "Allow",
        Action = ["s3:GetObject","s3:PutObject","s3:ListBucket"],
        Resource = ["*"]
      },
      {
        Sid    = "GlueAccess",
        Effect = "Allow",
        Action = ["glue:*","logs:*","cloudwatch:*"],
        Resource = ["*"]
      }
    ]
  })
}

output "glue_role_arn" { value = aws_iam_role.glue_role.arn }
