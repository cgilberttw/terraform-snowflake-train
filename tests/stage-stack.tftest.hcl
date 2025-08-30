# Test for Stage Stack
# This test validates the stage environment stack that creates STAGE database

run "stage_stack_test" {
  command = plan
  
  # Use the stage stack
  module {
    source = "./stacks/stage"
  }

  # Test 1: STAGE database is created
  assert {
    condition     = module.stage_database.database_name == "STAGE"
    error_message = "Stage database should be named 'STAGE', got '${module.stage_database.database_name}'"
  }

  # Test 2: Database comment contains environment info
  assert {
    condition     = can(regex("Environment: stage", module.stage_database.database_comment))
    error_message = "Database comment should contain 'Environment: stage', got '${module.stage_database.database_comment}'"
  }

  # Test 3: Database comment contains Data Mesh info
  assert {
    condition     = can(regex("Data Mesh", module.stage_database.database_comment))
    error_message = "Database comment should contain 'Data Mesh', got '${module.stage_database.database_comment}'"
  }

  # Test 4: Database comment contains managed by terraform
  assert {
    condition     = can(regex("Managed by: terraform", module.stage_database.database_comment))
    error_message = "Database comment should contain 'Managed by: terraform', got '${module.stage_database.database_comment}'"
  }
}
