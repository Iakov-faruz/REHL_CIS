#!/usr/bin/env bash
# CIS 6.3.3.15 - Ensure audit rules for chcon use are collected
echo "=== CIS 6.3.3.15 - Ensure audit rules for chcon use are collected ==="
echo "-a always,exit -F path=/usr/bin/chcon -F perm=x -F auid>=1000 -F auid!=unset -k perm_chng" > /etc/audit/rules.d/50-perm_chng.rules && augenrules --load
echo "[DONE] Remediation complete"
