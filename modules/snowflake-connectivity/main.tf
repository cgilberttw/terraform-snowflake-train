# Minimal Terraform connectivity test
# Tests basic connection to Snowflake

data "snowflake_current_account" "test" {}
