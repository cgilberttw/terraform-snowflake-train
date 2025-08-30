# Outputs from stage stack
output "stage_database" {
  description = "Stage database information"
  value = {
    database_name    = module.stage_database.database_name
    database_comment = module.stage_database.database_comment
    database_id      = module.stage_database.database_id
  }
}
