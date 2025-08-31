# Test: Auto-discovery of Data Products within Domains
# RED phase: This test should fail initially
# Tests the principle: domain/data_product/ = schema in domain database

run "data_product_auto_discovery_test" {
  command = plan

  # Test 1: At least one data product should be discovered
  assert {
    condition     = length(keys(module.data_products)) > 0
    error_message = "At least one data product should be auto-discovered from directory structure"
  }

  # Test 2: Each data product should create a schema with uppercase name
  assert {
    condition = alltrue([
      for dp_key, dp in module.data_products : 
      dp.schema_name == upper(split(".", dp_key)[1])
    ])
    error_message = "Each data product should create a schema with uppercase name (data_product → SCHEMA_NAME)"
  }

  # Test 3: Each schema should be in the correct database
  assert {
    condition = alltrue([
      for dp_key, dp in module.data_products : 
      dp.database_name == upper(split(".", dp_key)[0])
    ])
    error_message = "Each schema should be created in the correct domain database"
  }

  # Test 4: Each schema comment should contain data product info
  assert {
    condition = alltrue([
      for dp_key, dp in module.data_products : 
      can(regex("Data Product: ${split(".", dp_key)[1]}", dp.schema_comment))
    ])
    error_message = "Each schema comment should contain 'Data Product: data_product_name'"
  }
}
