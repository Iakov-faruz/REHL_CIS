#!/usr/bin/env bash
# CIS 5.2.5 - Ensure re-authentication for privilege escalation is not disabled globally (Remediation)
echo "=== CIS 5.2.5 - Removing !authenticate entries (Manual) ==="
echo "Based on the audit, use 'visudo -f <PATH TO FILE>' to edit the relevant sudoers file."
echo "Remove any occurrences of !authenticate tags in the file(s)."
echo ""
echo "Files to review:"
grep -rl "^[^#].*\!authenticate" /etc/sudoers* 2>/dev/null || echo " - No !authenticate entries found (already compliant)"
