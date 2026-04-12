#!/usr/bin/env bash
# CIS 6.3.3.3 - Ensure audit rules for sudo log are collected
echo "=== CIS 6.3.3.3 - Ensure audit rules for sudo log are collected ==="
echo "-w /var/log/sudo.log -p wa -k sudo_log" > /etc/audit/rules.d/50-sudo.rules && augenrules --load
echo "[DONE] Remediation complete"
