# Snowflake Database Module
# Creates a database with environment info in comment

resource "snowflake_database" "this" {
  name    = var.database_name
  comment = "${var.comment} | Environment: ${var.environment} | Managed by: terraform"
}
