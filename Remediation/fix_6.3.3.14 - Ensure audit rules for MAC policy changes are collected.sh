#!/usr/bin/env bash
# CIS 6.3.3.14 - Ensure audit rules for MAC policy changes are collected
echo "=== CIS 6.3.3.14 - Ensure audit rules for MAC policy changes are collected ==="
echo "-w /etc/selinux -p wa -k MAC-policy" > /etc/audit/rules.d/50-MAC-policy.rules && augenrules --load
echo "[DONE] Remediation complete"
