#!/usr/bin/env bash
# CIS 6.3.3.1 - Ensure audit rules for sudoers are collected
echo "=== CIS 6.3.3.1 - Ensure audit rules for sudoers are collected ==="
echo "-w /etc/sudoers -p wa -k scope" > /etc/audit/rules.d/50-scope.rules && augenrules --load
echo "[DONE] Remediation complete"
