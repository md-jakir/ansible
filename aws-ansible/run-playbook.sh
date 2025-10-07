#!/bin/bash

# Suppress urllib3 SSL warnings
export PYTHONWARNINGS="ignore:Unverified HTTPS request"

ansible-playbook vpcPlaybook.yml "$@"
