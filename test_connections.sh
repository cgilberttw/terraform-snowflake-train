#!/bin/bash

# Source environment variables
source .env

echo "Testing Snowflake connection..."
echo "Account: $SNOWFLAKE_ACCOUNT | User: $SNOWFLAKE_USER | Role: $SNOWFLAKE_ROLE"
echo ""

# Test 1: Basic connection and current context
echo "Current session info"
snowsql -a $SNOWFLAKE_ACCOUNT \
       -u $SNOWFLAKE_USER \
       -r $SNOWFLAKE_ROLE \
       --private-key-path $SNOWFLAKE_PRIVATE_KEY_PATH \
       -q "SELECT CURRENT_ACCOUNT() as account, CURRENT_USER() as user, CURRENT_ROLE() as role;" \
       -o header=true -o timing=false -o quiet=true

echo "Current session info OK"

# Test 2: Verify permissions
echo "Testing permissions"
snowsql -a $SNOWFLAKE_ACCOUNT \
       -u $SNOWFLAKE_USER \
       -r $SNOWFLAKE_ROLE \
       --private-key-path $SNOWFLAKE_PRIVATE_KEY_PATH \
       -q "SHOW DATABASES;" \
       -o header=true -o timing=false -o quiet=true

echo "Testing permissions OK"

# Test 3: Test database creation/deletion permissions
echo "Testing CREATE/DROP permissions"
snowsql -a $SNOWFLAKE_ACCOUNT \
       -u $SNOWFLAKE_USER \
       -r $SNOWFLAKE_ROLE \
       --private-key-path $SNOWFLAKE_PRIVATE_KEY_PATH \
       -q "CREATE DATABASE IF NOT EXISTS TEST_CONNECTION; DROP DATABASE IF EXISTS TEST_CONNECTION; SELECT 'CREATE/DROP permissions OK' as result;" \
       -o header=true -o timing=false -o quiet=true

echo "Testing CREATE/DROP permissions OK"

echo "Connection test completed!"
