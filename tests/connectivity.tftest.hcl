variables {}

run "connectivity_test" {
  command = plan

  # Test 1: Account connection - verify we can retrieve account information
  assert {
    condition     = data.snowflake_current_account.test.account != ""
    error_message = "Failed to retrieve current account information - connection issue or invalid credentials"
  }

  # Test 2: Account format validation - verify account is either legacy or organization-account format
  assert {
    condition = can(regex("^[A-Z0-9]+$", data.snowflake_current_account.test.account)) || can(regex("^[A-Z0-9]+-[A-Z0-9]+$", data.snowflake_current_account.test.account))
    error_message = "Connected account '${data.snowflake_current_account.test.account}' should be either legacy format (AO40357) or organization-account format (ORG-ACCOUNT)"
  }

  # Test 3: Organization consistency - verify organization name is set
  assert {
    condition     = var.snowflake_organization_name != ""
    error_message = "Organization name must be provided"
  }
}