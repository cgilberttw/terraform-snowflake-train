# Terraform Snowflake Data Mesh

Toy project for auto-provisioning infrastructure for Data Mesh with Snowflake for learning purpose


## Project Structure

```
terraform_snowflake_train/
├── domains.yaml                  # Domain configuration (add domains here)
├── main.tf                      # Auto-discovery logic
├── variables.tf + versions.tf   # Common Terraform config
├── modules/
│   ├── domain/                  # Domain module (creates databases)
│   └── data-product/            # Data product module (creates schemas)
├── finance/                     # Domain: Finance
│   └── data_products.yaml      # Data products: transactions
├── actors/                      # Domain: Actors  
│   └── data_products.yaml      # Data products: flights, companies
├── tests/                       # TDD tests
│   ├── domains.tftest.hcl       # Domain auto-discovery tests
│   └── data-products.tftest.hcl # Data product tests
├── env.example                  # Environment variables template
└── test_connections.sh          # Manual connection test
```

**Architecture principles:**
- **Auto-discovery**: Domains from `domains.yaml`, data products from YAML files
- **1 Domain = 1 Database**: `finance` → `FINANCE` database in Snowflake
- **1 Data Product = 1 Schema**: `transactions` → `TRANSACTIONS` schema
- **Configuration-driven**: Add domains/data products via config files
- **TDD validated**: All functionality tested before implementation

## Setup Guide

### Prerequisites

1. Snowflake trial account
2. Terraform >= 1.6 installed (`brew install terraform` on macOS)
3. SnowSQL CLI installed:
   - **macOS**: `brew install snowflake-snowsql`

### Step 1: Create Snowflake User and Role

Connect to your Snowflake account as ACCOUNTADMIN and execute:

```sql
-- Create dedicated role for Terraform
CREATE ROLE IF NOT EXISTS TERRAFORM_ROLE;

-- Create Terraform user WITHOUT password
CREATE USER IF NOT EXISTS TERRAFORM_USER
  DEFAULT_ROLE = TERRAFORM_ROLE
  MUST_CHANGE_PASSWORD = FALSE;

-- Assign role to user
GRANT ROLE TERRAFORM_ROLE TO USER TERRAFORM_USER;

-- Grant necessary permissions to role
GRANT CREATE DATABASE ON ACCOUNT TO ROLE TERRAFORM_ROLE;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE TERRAFORM_ROLE;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE TERRAFORM_ROLE;
```

### Step 2: Generate RSA Key Pair

```bash
# Create directory for Snowflake keys
mkdir -p ~/.snowflake

# Generate private key
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out ~/.snowflake/snowflake_tf_snow_key.p8 -nocrypt

# Generate public key
openssl rsa -in ~/.snowflake/snowflake_tf_snow_key.p8 -pubout -out ~/.snowflake/snowflake_tf_snow_key.pub
```

### Step 3: Configure Public Key in Snowflake

1. Read your public key content:
```bash
cat ~/.snowflake/snowflake_tf_snow_key.pub
```

2. Copy the content (without the `-----BEGIN PUBLIC KEY-----` and `-----END PUBLIC KEY-----` lines) and execute in Snowflake:
```sql
ALTER USER TERRAFORM_USER SET RSA_PUBLIC_KEY='PASTE_YOUR_PUBLIC_KEY_CONTENT_HERE';
```

### Step 4: Configure Environment

1. Copy the example configuration file:
```bash
cp env.example .env
```

2. Edit `.env` with your actual values:
- `SNOWFLAKE_ORGANIZATION_NAME`: Your organization name (empty "" for legacy accounts)
- `SNOWFLAKE_ACCOUNT_NAME`: Your account name (full account for legacy accounts like AO40357)
- `SNOWFLAKE_USER`: TERRAFORM_USER
- `SNOWFLAKE_PRIVATE_KEY_LOCAL_PATH`: ~/.snowflake/snowflake_tf_snow_key.p8
- `SNOWFLAKE_ROLE`: TERRAFORM_ROLE
and source it
```bash
bash .env
```

### Step 5: Manual Test Connection

```bash
./test_connections.sh
```

### Step 6: Terraform Automated Test

Load environment variables and run tests from project root:
```bash
source .env
terraform init
terraform test
```

## Deploy Data Mesh Infrastructure

### Step 7: Deploy All Domains and Data Products

1. Initialize Terraform:
```bash
terraform init
```

2. Review what will be created:
```bash
terraform plan
```

3. Deploy the infrastructure:
```bash
terraform apply
```

This will automatically create databases and schemas based on your configuration.

## Add New Domain

1. Edit `domains.yaml`: Add domain name
2. Create directory: `mkdir marketing`  
3. Create `marketing/data_products.yaml`:
```yaml
campaigns:
  data_classification: l2
```
4. Deploy: `terraform apply`

## Add Data Product

Edit existing domain's `data_products.yaml`:
```yaml
existing_product:
  data_classification: l1
new_product:
  data_classification: l2
```
Deploy: `terraform apply`

## Test & Deploy

```bash
source .env
terraform init
terraform test    # Validate
terraform apply   # Deploy
```