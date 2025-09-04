# Data Product Module
# Creates a Snowflake schema for a data product within a domain database

resource "snowflake_schema" "this" {
  database = var.database_name
  name     = upper(var.data_product_name)
  comment  = "${var.comment} | Data Product: ${var.data_product_name} | Domain: ${var.domain_name} | Managed by: terraform"
}

# Associate domain tag with the schema
resource "snowflake_tag_association" "domain_tag_association" {
  tag_id             = var.domain_tag_id
  object_type        = "SCHEMA"
  object_identifiers = ["${var.database_name}.${snowflake_schema.this.name}"]
  tag_value          = var.domain_name
}

# Associate data-product-name tag with the schema
resource "snowflake_tag_association" "data_product_name_tag_association" {
  tag_id             = var.data_product_name_tag_id
  object_type        = "SCHEMA"
  object_identifiers = ["${var.database_name}.${snowflake_schema.this.name}"]
  tag_value          = var.data_product_name
}

# Create empty metadata table for the data product
resource "snowflake_table" "metadata" {
  database = var.database_name
  schema   = snowflake_schema.this.name
  name     = "METADATA"
  comment  = "Metadata table for ${var.data_product_name} data product"

  column {
    name = "DATA_PRODUCT_NAME"
    type = "STRING"
  }

  column {
    name = "DOMAIN"
    type = "STRING"
  }

  column {
    name = "TABLE_NAME"
    type = "STRING"
  }

  column {
    name = "DATA_CLASSIFICATION"
    type = "STRING"
  }
}
