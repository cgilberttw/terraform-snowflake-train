# Terraform Snowflake Data Mesh

Terraform infrastructure for Data Mesh with Snowflake

## Setup Guide

### Prerequisites

1. Snowflake trial account
2. SnowSQL CLI installed:
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
- `SNOWFLAKE_ACCOUNT`: Your Snowflake account identifier
- `SNOWFLAKE_USER`: TERRAFORM_USER
- `SNOWFLAKE_PRIVATE_KEY_PATH`: ~/.snowflake/snowflake_tf_snow_key.p8
- `SNOWFLAKE_ROLE`: TERRAFORM_ROLE

### Step 5: Manual Test Connection

```bash
./test_connections.sh
```
