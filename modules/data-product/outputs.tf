output "schema_name" {
  description = "Name of the created schema"
  value       = snowflake_schema.this.name
}

output "schema_comment" {
  description = "Comment of the created schema"
  value       = snowflake_schema.this.comment
}

output "schema_id" {
  description = "ID of the created schema"
  value       = snowflake_schema.this.id
}

output "database_name" {
  description = "Name of the database containing the schema"
  value       = var.database_name
}

output "data_product_name" {
  description = "Original data product name (lowercase)"
  value       = var.data_product_name
}

output "domain_name" {
  description = "Domain name this data product belongs to"
  value       = var.domain_name
}

output "schema_tags" {
  description = "Tags applied to the schema"
  value = {
    domain            = var.domain_name
    data_product_name = var.data_product_name
  }
}

output "metadata_table" {
  description = "Information about the metadata table"
  value = {
    name      = snowflake_table.metadata.name
    full_name = "${var.database_name}.${snowflake_schema.this.name}.${snowflake_table.metadata.name}"
    columns   = ["DATA_PRODUCT_NAME", "DOMAIN", "TABLE_NAME", "DATA_CLASSIFICATION"]
  }
}
