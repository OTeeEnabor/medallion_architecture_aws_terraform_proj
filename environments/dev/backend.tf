
terraform {
  backend "s3" {
    bucket         = "CHANGE_ME-state-bucket"
    key            = "medallion-aws/dev/terraform.tfstate"
    region         = "${var.aws_region}"
    dynamodb_table = "CHANGE_ME-lock-table"
    encrypt        = true
  }
}
