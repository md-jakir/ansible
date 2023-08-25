# Ansible
Configuration management and provisioning tool for private or cloud infrastructure. 

- Upcomming:
    
      - Ansible Handler

  # Ansible playbook commands with options

  1. ansible-playbook test.yml --check
  2. ansible-playbook test.yml --start-at-task [TASK_NAME]
  3. E.X: ansible-playbook first-ansible.yml --start-at-task "uptime_machine"
  4. ansible-playbook test.yml --tags [tag_name]
  5. ansible-playbook test.yml --skip-tags [tag_name]
  6. 
