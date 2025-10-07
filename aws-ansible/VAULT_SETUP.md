# HashiCorp Vault Integration Setup

This guide will help you set up HashiCorp Vault integration with your AWS Ansible playbook.

## Prerequisites

1. **HashiCorp Vault installed and running**
   ```bash
   # Install Vault (Ubuntu/Debian)
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install vault
   ```

2. **Ansible with community.hashi_vault collection**
   ```bash
   ansible-galaxy collection install community.hashi_vault
   ```

3. **jq (for JSON processing)**
   ```bash
   sudo apt install jq
   ```

## Quick Setup

### Step 1: Start Vault (Development Mode)
```bash
# In a separate terminal, start Vault in dev mode
vault server -dev
```

### Step 2: Run the Setup Script
```bash
cd /mnt/d/ansible/aws-ansible
./vault-setup.sh
```

This script will:
- Enable KV v2 secrets engine
- Create a secret with your AWS credentials
- Create an Ansible policy
- Generate a token for Ansible

### Step 3: Set Environment Variables
The setup script will output the required environment variables. Set them:
```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='your_token_here'
export VAULT_SKIP_VERIFY=true
```

### Step 4: Test the Integration
```bash
./test-vault.sh
```

### Step 5: Run Your Playbook
```bash
ansible-playbook vpcPlaybook.yml
```

## Manual Setup (Alternative)

If you prefer to set up manually:

### 1. Enable KV v2 Secrets Engine
```bash
export VAULT_ADDR='http://127.0.0.1:8200'
vault secrets enable -path=ansible-lab kv-v2
```

### 2. Store AWS Credentials
```bash
vault kv put ansible-lab/ntech_aws_access \
    aws_access_key="YOUR_AWS_ACCESS_KEY" \
    aws_secret_key="YOUR_AWS_SECRET_KEY"
```

### 3. Create Ansible Policy
```bash
vault policy write ansible-policy - <<EOF
path "ansible-lab/data/ntech_aws_access" {
  capabilities = ["read"]
}
EOF
```

### 4. Create Token
```bash
TOKEN=$(vault token create -policy=ansible-policy -format=json | jq -r '.auth.client_token')
export VAULT_TOKEN="$TOKEN"
```

## Troubleshooting

### Common Issues

1. **"Invalid or missing path" error**
   - Ensure the secret path exists: `vault kv get ansible-lab/ntech_aws_access`
   - Check the key names match: `aws_access_key` and `aws_secret_key`

2. **"Unverified HTTPS request" warning**
   - This is expected in development mode
   - Set `VAULT_SKIP_VERIFY=true` to suppress

3. **"ANSIBLE_COLLECTIONS_PATHS" deprecation warning**
   - Fixed by the included `ansible.cfg` file

4. **Collection not found**
   - Install the collection: `ansible-galaxy collection install community.hashi_vault`

### Verify Your Setup

```bash
# Check Vault status
vault status

# List secrets
vault kv list ansible-lab/

# Read your secret
vault kv get ansible-lab/ntech_aws_access

# Test Ansible lookup
ansible localhost -m ansible.builtin.debug -a "msg={{ lookup('community.hashi_vault.vault_kv2_get', 'ansible-lab/ntech_aws_access', 'aws_access_key') }}"
```

## Security Notes

- This setup uses Vault in development mode (not for production)
- For production, use proper TLS certificates and authentication methods
- Consider using Vault's AWS authentication method for better security
- Never commit Vault tokens or AWS credentials to version control

## File Structure

```
aws-ansible/
├── vpcPlaybook.yml          # Main playbook
├── ansible.cfg              # Ansible configuration
├── vault-setup.sh           # Vault setup script
├── test-vault.sh            # Integration test script
├── VAULT_SETUP.md           # This documentation
└── roles/aws-vpc/
    ├── tasks/
    │   ├── main.yml         # Main tasks
    │   └── vault_creds.yml  # Vault credential tasks
    └── vars/
        └── vars.yml         # Variables with Vault lookups
```
