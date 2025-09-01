# Test: Auto-discovery of Domains (Generic)
# RED phase: This test should fail initially
# Tests the principle: any directory at root = domain = database

run "domain_auto_discovery_test" {
  command = plan

  # Test 1: At least one domain should be discovered
  assert {
    condition     = length(keys(module.domains)) > 0
    error_message = "At least one domain should be auto-discovered from directory structure"
  }

  # Test 2: Each discovered domain should create a database with uppercase name
  assert {
    condition = alltrue([
      for domain_name, domain in module.domains :
      domain.database_name == upper(domain_name)
    ])
    error_message = "Each domain should create a database with uppercase name (domain_name → DATABASE_NAME)"
  }

  # Test 3: Each database comment should contain domain info
  assert {
    condition = alltrue([
      for domain_name, domain in module.domains :
      can(regex("Domain: ${domain_name}", domain.database_comment))
    ])
    error_message = "Each database comment should contain 'Domain: domain_name'"
  }
}
