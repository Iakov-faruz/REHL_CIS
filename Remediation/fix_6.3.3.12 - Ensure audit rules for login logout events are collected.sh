#!/usr/bin/env bash
# CIS 6.3.3.12 - Ensure audit rules for login logout events are collected
echo "=== CIS 6.3.3.12 - Ensure audit rules for login logout events are collected ==="
echo "-w /var/log/lastlog -p wa -k logins" > /etc/audit/rules.d/50-login.rules && augenrules --load
echo "[DONE] Remediation complete"
