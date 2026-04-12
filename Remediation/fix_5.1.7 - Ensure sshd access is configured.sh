#!/usr/bin/env bash
# CIS 5.1.7 - Ensure sshd access is configured (Remediation)
# Set AllowUsers or AllowGroups as per site policy

echo "=== CIS 5.1.7 - Configuring sshd access (Manual) ==="
echo "Edit /etc/ssh/sshd_config and set one or more of the following parameters"
echo "above any Include and Match set statements:"
echo ""
echo "  AllowUsers <userlist>"
echo "  - AND/OR -"
echo "  AllowGroups <grouplist>"
echo ""
echo "Note:"
echo "  - First occurrence of an option takes precedence"
echo "  - AllowUsers and AllowGroups are ANDed together"
echo "  - It is easier to manage an allow list than a deny list"
echo ""
echo "This script does NOT make changes automatically because the user/group"
echo "lists must be defined according to local site policy."
