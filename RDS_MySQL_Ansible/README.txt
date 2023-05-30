# COMMANDS:

- ansible-playbook table_bak_aws_rds.yml

# Note:

If we encrypt the vault file means sensitive data then 

- ansible-vault encrypt db_vault.yml 

And you will be asking to provide password

During playbook execution have to pass vault password like this

- ansible-playbook table_bak_aws_rds.yml --ask-vault-password
