#!/usr/bin/env bash
# CIS 6.3.3.2 - Ensure audit rules for user emulation are collected
echo "=== CIS 6.3.3.2 - Ensure audit rules for user emulation are collected ==="
echo "-w /var/log/sudo.log -p wa -k sudo_log" > /etc/audit/rules.d/50-user_emulation.rules && augenrules --load
echo "[DONE] Remediation complete"
