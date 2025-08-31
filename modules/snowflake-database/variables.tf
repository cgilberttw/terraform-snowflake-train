variable "database_name" {
  description = "Name of the Snowflake database"
  type        = string
}

variable "comment" {
  description = "Comment for the database"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name (stage, prod)"
  type        = string
}
