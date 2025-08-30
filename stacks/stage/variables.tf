# Snowflake connection variables for stage stack
variable "snowflake_organization_name" {
  type        = string
  description = "Your Snowflake organization name."
}

variable "snowflake_account" {
  type        = string
  description = "Your Snowflake account name."
}

variable "snowflake_user" {
  type        = string
  description = "The username for authentication."
}

variable "snowflake_private_key_path" {
  type        = string
  description = "The path to the user's private key for authentication."
  sensitive   = true
}

variable "snowflake_role" {
  type        = string
  description = "The role to use for the Terraform session."
}
