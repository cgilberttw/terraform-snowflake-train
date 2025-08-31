variable "data_product_name" {
  description = "Name of the data product (will be converted to uppercase for schema name)"
  type        = string
}

variable "domain_name" {
  description = "Name of the domain this data product belongs to"
  type        = string
}

variable "database_name" {
  description = "Name of the database where the schema will be created"
  type        = string
}

variable "comment" {
  description = "Comment for the schema"
  type        = string
  default     = "Data Mesh data product schema"
}
