#!/usr/bin/env bash
# CIS 6.3.3.9 - Ensure audit rules for DAC permission changes are collected
echo "=== CIS 6.3.3.9 - Ensure audit rules for DAC permission changes are collected ==="
echo "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=unset -F key=perm_mod" > /etc/audit/rules.d/50-perm_mod.rules && augenrules --load
echo "[DONE] Remediation complete"
