#!/usr/bin/env bash
# CIS 5.3.2.1 - Ensure active authselect profile includes pam modules (Remediation)

echo "=== CIS 5.3.2.1 - Creating/selecting custom authselect profile ==="
echo "Run the following commands to create and select a custom authselect profile:"
echo ""
echo "  # authselect create-profile custom-profile -b sssd"
echo "  # authselect select custom/custom-profile --backup=PAM_CONFIG_BACKUP --force"
echo ""
echo "Then verify the profile includes pam_pwquality, pam_pwhistory, pam_faillock, and pam_unix modules."
echo ""
echo "Note:"
echo "  - --backup creates backup at /var/lib/authselect/backups/"
echo "  - --force overwrites existing configuration"
echo "  - Do NOT use authselect if host is part of IdM or AD via SSSD"
