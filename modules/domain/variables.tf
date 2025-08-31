variable "domain_name" {
  description = "Name of the domain (will be converted to uppercase for database name)"
  type        = string
}

variable "comment" {
  description = "Comment for the database"
  type        = string
  default     = "Data Mesh domain database"
}
