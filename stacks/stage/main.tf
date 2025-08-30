# Stage Stack
# Creates the STAGE database using the snowflake-database module

module "stage_database" {
  source = "../../modules/snowflake-database"
  
  database_name                 = "STAGE"
  environment                   = "stage"
  comment                       = "Stage environment database for Data Mesh"
  
  # Snowflake connection variables
  snowflake_organization_name   = var.snowflake_organization_name
  snowflake_account            = var.snowflake_account
  snowflake_user               = var.snowflake_user
  snowflake_private_key_path   = var.snowflake_private_key_path
  snowflake_role               = var.snowflake_role
}
