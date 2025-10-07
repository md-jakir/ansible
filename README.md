# Ansible Document
Configuration management and provisioning tool for private or cloud infrastructure. 

- Upcoming:
    
      - Ansible Handler

  # Ansible playbook commands with options

  1. ansible-playbook test.yml --check
  2. ansible-playbook test.yml --start-at-task [TASK_NAME]
  3. E.X: ansible-playbook first-ansible.yml --start-at-task "uptime_machine"
  4. ansible-playbook test.yml --tags [tag_name]
  5. ansible-playbook test.yml --skip-tags [tag_name]

# Some Ansible questions

1. You have an ansible playbook that configures a server with a specific package. You want to run the playbook on a group of servers, but you want to skip the task that installs the package on a specific server. How would you do this?

    To skip a task for a specific host, you can use the `--limit` option and specify the hostname or pattern to match the host you want to skip.

        ansible-playbook --limit '!server1' playbook.yml

2. You have an Ansible playbook that installs and configures a web server. You want to run the playbook, but you want to test the changes before making them. How would you do this?

    To test the changes made by an Ansible playbook without making any actual changes, you can use the `--check flag`. This will perform a "dry run" of the playbook and report any changes that would be made, but it will not make any changes on the target hosts.

        ansible-playbook --check playbook.yml

3. You have an Ansible playbook that installs and configures a database server. You want to run the playbook, but you want to make it so that any failures will be ignored, and the playbook will continue to run. How would you do this?

    To ignore failures and continue running the playbook, you can use the `--force-handlers` flag. This will cause Ansible to continue running the playbook even if a task fails, and it will run any handlers (tasks that are triggered by other tasks) that were registered for the failed tasks.

       ansible-playbook --force-handlers playbook.yml

4. You have an Ansible playbook that installs and configures a load balancer. You want to run the playbook, but you want to make it so that any tasks that would change the target hosts will be skipped. How would you do this?

    To skip tasks that would make changes to the target hosts, you can use the `--diff` flag. This will perform a "dry run" of the playbook and report any changes that would be made, but it will skip any tasks that would make actual changes on the target hosts.

       ansible-playbook --diff playbook.yml

5. You have an ansible playbook that installs and configures a monitoring system. You want to run the playbook, but you want to make it so that any tasks that are not idempotent (i.e., tasks that cannot be run multiple times without causing harm) will be skipped. How would you do this?

   To skip non-idempotent tasks, you can use the `--skip-tags` flag and specify the tag or tags for the tasks you want to skip.

       ansible-playbook --skip-tags non_idempotent playbook.yml

6. You have an Ansible playbook that installs and configures a file server. You want to run the playbook, but you want to make it so that any tasks that are not relevant to the target hosts will be skipped. How would you do this?

   To skip tasks that are not relevant to the target hosts, you can use the `--skip-tags` flag and specify the tag or tags for the tasks you want to skip.

       ansible-playbook --skip-tags '!file_server' playbook.yml

9. You want to install a package on all of the servers in your inventory using the package manager for the target operating system. How would you do this using Ansible?

    You can use the `package` module to install a package on all of the servers in your inventory using the package manager for the target operating system.

       - name: Install package
          hosts: all
          tasks:
            - name: Install package
              package:
                name: nginx

