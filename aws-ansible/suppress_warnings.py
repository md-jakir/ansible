#!/usr/bin/env python3
"""
Script to suppress urllib3 SSL warnings for Vault connections
"""
import warnings
import urllib3

# Suppress urllib3 SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Suppress other SSL warnings
warnings.filterwarnings('ignore', message='Unverified HTTPS request')
