Role aws-vpc

This role can obtain AWS credentials from HashiCorp Vault using the
`community.hashi_vault` lookup plugin.

Usage

- Ensure `community.hashi_vault` collection is installed:

  ansible-galaxy collection install community.hashi_vault

- Provide Vault connection info via environment variables (VAULT_ADDR, VAULT_TOKEN)
  or via the lookup plugin configuration.

- Set `vault_aws_secret_path` to the secret path containing fields
  `aws_access_key_id` and `aws_secret_access_key` (or set `aws_access_key`
  and `aws_secret_key` through inventory/group_vars if not using Vault).

Example group_vars/all.yml

aws_region: ap-southeast-1
vault_aws_secret_path: secret/data/ansible/aws

Security

Do not commit AWS credentials to source control. Prefer Vault or Ansible Vault for
sensitive data.
