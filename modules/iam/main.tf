
variable "project"     { type = string }
variable "environment" { type = string }
variable "tags"        { type = map(string) }


resource "aws_iam_policy" "data_lake_access_policy" {
  name = "S3DataLakePolicy-${aws_s3_bucket.lake.bucket}"
  description = "This policy allows for running glue jobs in the glue console and access data lake."
  policy = data.aws_iam_policy_document.data_lake_policy.json
  tags = var.tags
} 


resource "aws_iam_role" "glue_role" {
  name = "${var.project}-${var.environment}-glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_role.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "data_lake_permissions" {
  role = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.data_lake_access_policy.arn
}


resource "aws_iam_policy" "lambda_s3_policy" {
  name ="${var.project}-bronze-lambda-s3-policy"
  policy = data.aws_iam_policy_document.lambda_s3_policy.json
  tags = var.tags
}
resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-${var.environment}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda-role.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_s3_attach"{
  role = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy 

}
# create IAM role to use glue service
# resource "aws_iam_role" "glue_role" {
#   name = "${var.project}-${var.environment}-glue-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Principal = { Service = "glue.amazonaws.com" }
#       Effect = "Allow"
#     }]
#   })
#   tags = var.tags
# }

# # create IAM policy to be used by glue_role
# resource "aws_iam_role_policy" "glue_policy" {
#   name = "${var.project}-${var.environment}-glue-policy"
#   role = aws_iam_role.glue_role.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid    = "S3Access",
#         Effect = "Allow",
#         Action = ["s3:GetObject","s3:PutObject","s3:ListBucket"],
#         Resource = ["*"]
#       },
#       {
#         Sid    = "GlueAccess",
#         Effect = "Allow",
#         Action = ["glue:*","logs:*","cloudwatch:*"],
#         Resource = ["*"]
#       }
#     ]
#   })
# }

output "glue_role_arn" { value = aws_iam_role.glue_role.arn }
