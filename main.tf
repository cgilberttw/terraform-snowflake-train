# Data Mesh Infrastructure
# Auto-discovery of domains from directory structure

# Snowflake Provider Configuration
provider "snowflake" {
  organization_name = var.snowflake_organization_name
  account_name      = var.snowflake_account
  user              = var.snowflake_user
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.snowflake_private_key_path)
  role              = var.snowflake_role
}

# Auto-discover domains and data products from directory structure
locals {
  # Load domains configuration from external YAML file
  domains_config    = yamldecode(file("domains.yaml"))
  potential_domains = local.domains_config.domains

  # Filter to keep only domains that actually exist as directories
  domains = toset([
    for domain in local.potential_domains : domain
    if can(fileset("${domain}", "*"))
  ])

  # Auto-discover data products from YAML files within each domain
  data_products_raw = flatten([
    for domain in local.domains : [
      for data_product_name, config in yamldecode(file("${domain}/data_products.yaml")) : {
        key               = "${domain}.${data_product_name}"
        domain_name       = domain
        data_product_name = data_product_name
        database_name     = upper(domain)
        config            = config
      }
    ]
  ])

  # Convert to map for for_each
  data_products = {
    for dp in local.data_products_raw : dp.key => dp
  }
}

# Create databases for each discovered domain
module "domains" {
  source = "./modules/domain"

  for_each = local.domains

  domain_name = each.key
  comment     = "Domain database for ${each.key}"
}

# Create schemas for each discovered data product
module "data_products" {
  source = "./modules/data-product"

  for_each = local.data_products

  data_product_name = each.value.data_product_name
  domain_name       = each.value.domain_name
  database_name     = each.value.database_name
  comment           = "Data product schema for ${each.value.data_product_name} in ${each.value.domain_name} domain"

  # Ensure the database exists before creating the schema
  depends_on = [module.domains]
}
