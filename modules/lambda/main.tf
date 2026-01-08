
variable "bucket_name"   { type = string }
# variable "landing_prefix" { type = string  default = "landing/" }
# variable "bronze_prefix"  { type = string  default = "bronze/" }
# variable "lambda_name"    { 
#     type = string  
#     default = "unzip-to-bronze" 
# }
# variable "aws_region"     { type = string  default = "eu-west-1" }

# # ----- IAM role for Lambda -----
# resource "aws_iam_role" "lambda_role" {
#   name = "${var.lambda_name}-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect = "Allow",
#       Principal = { Service = "lambda.amazonaws.com" },
#       Action   = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_basic_logs" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# # Narrow S3 permissions to bucket and prefixes
# resource "aws_iam_policy" "lambda_s3_policy" {
#   name   = "${var.lambda_name}-s3-policy"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid: "ReadLanding",
#         Effect: "Allow",
#         Action: ["s3:GetObject","s3:ListBucket"],
#         Resource: [
#           "arn:aws:s3:::${var.bucket_name}",
#           "arn:aws:s3:::${var.bucket_name}/${var.landing_prefix}*"
#         ]
#       },
#       {
#         Sid: "WriteBronze",
#         Effect: "Allow",
#         Action: ["s3:PutObject","s3:AbortMultipartUpload"],
#         Resource: [
#           "arn:aws:s3:::${var.bucket_name}/${var.bronze_prefix}*"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_s3_attach" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = aws_iam_policy.lambda_s3_policy.arn
# }

# ----- Package Lambda code locally -----
# Assumes lambda_unzip_to_bronze.py is in ./lambda-src/
# data "archive_file" "lambda_zip" {
#   type        = "zip"
#   source_dir  = "${path.module}/lambda-src"
#   output_path = "${path.module}/build/unzip_to_bronze.zip"
# }

