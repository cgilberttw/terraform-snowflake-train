# Data Product Module
# Creates a Snowflake schema for a data product within a domain database

resource "snowflake_schema" "this" {
  database = var.database_name
  name     = upper(var.data_product_name)
  comment  = "${var.comment} | Data Product: ${var.data_product_name} | Domain: ${var.domain_name} | Managed by: terraform"
}
