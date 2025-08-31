# Domain Module
# Creates a Snowflake database for a domain

resource "snowflake_database" "this" {
  name    = upper(var.domain_name)
  comment = "${var.comment} | Domain: ${var.domain_name} | Managed by: terraform"
}
