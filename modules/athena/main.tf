resource "aws_athena_workgroup" "wg" {
  name = "${var.project}_${var.environment}_wg"
  configuration {
    result_configuration {
      output_location = "s3://${var.project}-${var.environment}-lake/${var.query_results_s3}"
    }
    enforce_workgroup_configuration = true
  }
  tags = var.tags
}

output "workgroup_name" { value = aws_athena_workgroup.wg.name }
