output "current_account" {
  description = "Current Snowflake account"
  value       = data.snowflake_current_account.test.account
}

output "connection_summary" {
  description = "Summary of current Snowflake connection"
  value = {
    account = data.snowflake_current_account.test.account
    user    = var.snowflake_user
    role    = var.snowflake_role
  }
}
