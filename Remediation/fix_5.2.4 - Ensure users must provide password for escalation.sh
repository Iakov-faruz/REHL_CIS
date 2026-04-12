#!/usr/bin/env bash
# CIS 5.2.4 - Ensure users must provide password for escalation (Remediation)
echo "=== CIS 5.2.4 - Removing NOPASSWD entries (Manual) ==="
echo "Based on the audit, use 'visudo -f <PATH TO FILE>' to edit the relevant sudoers file."
echo "Remove any line with occurrences of NOPASSWD tags."
echo ""
echo "Files to review:"
grep -rl "^[^#].*NOPASSWD" /etc/sudoers* 2>/dev/null || echo " - No NOPASSWD entries found (already compliant)"
