
resource "aws_glue_catalog_database" "db" {
  name = "${var.project}_${var.environment}_db"
}

resource "aws_glue_crawler" "bronze" {
  name          = "${var.project}-${var.environment}-bronze-crawler"
  database_name = aws_glue_catalog_database.db.name
  role          = var.glue_role_arn
  s3_target {
    path = "s3://${var.s3_bucket_name}/${var.bronze_prefix}"
  }
  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DEPRECATE_IN_DATABASE"
  }
}

# resource "aws_glue_crawler" "silver" {
#   name          = "${var.project}-${var.environment}-silver-crawler"
#   database_name = aws_glue_catalog_database.db.name
#   role          = var.glue_role_arn

#   s3_target {
#     path = "s3://${var.s3_bucket_name}/${var.silver_prefix}"
#   }

#   schema_change_policy {
#     update_behavior = "UPDATE_IN_DATABASE"
#     delete_behavior = "DEPRECATE_IN_DATABASE"
#   }
# }

# resource "aws_glue_crawler" "gold" {
#   name          = "${var.project}-${var.environment}-gold-crawler"
#   database_name = aws_glue_catalog_database.db.name
#   role          = var.glue_role_arn

#   s3_target {
#     path = "s3://${var.s3_bucket_name}/${var.gold_prefix}"
#   }

#   schema_change_policy {
#     update_behavior = "UPDATE_IN_DATABASE"
#     delete_behavior = "DEPRECATE_IN_DATABASE"
#   }
# }

output "database_name" { value = aws_glue_catalog_database.db.name }
