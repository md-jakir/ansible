#!/bin/bash

# Vault Setup Script for AWS Ansible Integration
# This script helps set up HashiCorp Vault for AWS credentials

echo "=== HashiCorp Vault Setup for AWS Ansible ==="

# Check if Vault is installed
if ! command -v vault &> /dev/null; then
    echo "Vault is not installed. Please install HashiCorp Vault first."
    echo "Visit: https://www.vaultproject.io/downloads"
    exit 1
fi

# Set Vault environment variables
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_SKIP_VERIFY=true

echo "Setting up Vault environment..."
echo "VAULT_ADDR: $VAULT_ADDR"
echo "VAULT_SKIP_VERIFY: $VAULT_SKIP_VERIFY"

# Check if Vault is running
if ! vault status &> /dev/null; then
    echo "Vault is not running. Please start Vault first:"
    echo "vault server -dev"
    exit 1
fi

echo "Vault is running and accessible."

# Enable KV v2 secrets engine
echo "Enabling KV v2 secrets engine..."
vault secrets enable -path=ansible-lab kv-v2

# Create the secret with AWS credentials
echo "Creating AWS credentials secret..."
echo "Please provide your AWS credentials:"
read -p "AWS Access Key ID: " AWS_ACCESS_KEY
read -s -p "AWS Secret Access Key: " AWS_SECRET_KEY
echo

# Store the credentials in Vault
vault kv put ansible-lab/ntech_aws_access \
    aws_access_key="$AWS_ACCESS_KEY" \
    aws_secret_key="$AWS_SECRET_KEY"

echo "AWS credentials stored in Vault at path: ansible-lab/ntech_aws_access"

# Create a policy for Ansible
echo "Creating Ansible policy..."
vault policy write ansible-policy - <<EOF
path "ansible-lab/data/ntech_aws_access" {
  capabilities = ["read"]
}
EOF

# Create a token for Ansible
echo "Creating token for Ansible..."
TOKEN=$(vault token create -policy=ansible-policy -format=json | jq -r '.auth.client_token')
export VAULT_TOKEN="$TOKEN"

echo "=== Setup Complete ==="
echo "Vault Token: $TOKEN"
echo "Export these environment variables:"
echo "export VAULT_ADDR='http://127.0.0.1:8200'"
echo "export VAULT_TOKEN='$TOKEN'"
echo "export VAULT_SKIP_VERIFY=true"
echo ""
echo "You can now run your Ansible playbook!"
