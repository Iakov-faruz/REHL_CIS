#!/usr/bin/env bash
# CIS 6.3.3.8 - Ensure audit rules for user group changes are collected
echo "=== CIS 6.3.3.8 - Ensure audit rules for user group changes are collected ==="
echo "-w /etc/group -p wa -k identity" > /etc/audit/rules.d/50-identity.rules && augenrules --load
echo "[DONE] Remediation complete"
