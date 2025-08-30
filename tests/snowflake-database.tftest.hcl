# Test for Snowflake Database Module
# Tests the snowflake-database module in isolation

run "database_module_test" {
  command = plan
  
  # Test the database module directly
  module {
    source = "./modules/snowflake-database"
  }
  
  variables {
    database_name = "TEST_DB"
    environment   = "test"
    comment       = "Test database"
  }

  # Test 1: Database is created with correct name
  assert {
    condition     = snowflake_database.this.name == "TEST_DB"
    error_message = "Database name should be 'TEST_DB', got '${snowflake_database.this.name}'"
  }

  # Test 2: Database comment contains environment info
  assert {
    condition     = can(regex("Environment: test", snowflake_database.this.comment))
    error_message = "Database comment should contain 'Environment: test', got '${snowflake_database.this.comment}'"
  }

  # Test 3: Database comment contains managed_by info
  assert {
    condition     = can(regex("Managed by: terraform", snowflake_database.this.comment))
    error_message = "Database comment should contain 'Managed by: terraform', got '${snowflake_database.this.comment}'"
  }

  # Test 4: Database comment contains original description
  assert {
    condition     = can(regex("Test database", snowflake_database.this.comment))
    error_message = "Database comment should contain 'Test database', got '${snowflake_database.this.comment}'"
  }


}
