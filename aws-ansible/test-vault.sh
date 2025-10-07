#!/bin/bash

# Test Vault Integration Script
echo "=== Testing Vault Integration ==="

# Check if required environment variables are set
if [ -z "$VAULT_ADDR" ]; then
    echo "Error: VAULT_ADDR environment variable is not set"
    echo "Please run: export VAULT_ADDR='http://127.0.0.1:8200'"
    exit 1
fi

if [ -z "$VAULT_TOKEN" ]; then
    echo "Error: VAULT_TOKEN environment variable is not set"
    echo "Please run the vault-setup.sh script first"
    exit 1
fi

echo "VAULT_ADDR: $VAULT_ADDR"
echo "VAULT_TOKEN: ${VAULT_TOKEN:0:10}..."

# Test Vault connection
echo "Testing Vault connection..."
if vault status &> /dev/null; then
    echo "✓ Vault connection successful"
else
    echo "✗ Vault connection failed"
    exit 1
fi

# Test reading the secret
echo "Testing secret retrieval..."
SECRET=$(vault kv get -field=aws_access_key ansible-lab/ntech_aws_access 2>/dev/null)
if [ $? -eq 0 ] && [ -n "$SECRET" ]; then
    echo "✓ Secret retrieval successful"
    echo "AWS Access Key (first 10 chars): ${SECRET:0:10}..."
else
    echo "✗ Secret retrieval failed"
    echo "Please ensure the secret exists at ansible-lab/ntech_aws_access"
    exit 1
fi

# Test Ansible lookup
echo "Testing Ansible Vault lookup..."
cd /mnt/d/ansible/aws-ansible
ansible localhost -m ansible.builtin.debug -a "msg={{ lookup('community.hashi_vault.vault_kv2_get', 'ansible-lab/ntech_aws_access', 'aws_access_key') }}" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Ansible Vault lookup successful"
else
    echo "✗ Ansible Vault lookup failed"
    echo "Please ensure the community.hashi_vault collection is installed:"
    echo "ansible-galaxy collection install community.hashi_vault"
    exit 1
fi

echo "=== All tests passed! ==="
echo "You can now run your playbook with:"
echo "ansible-playbook vpcPlaybook.yml"
