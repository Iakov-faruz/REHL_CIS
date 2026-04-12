#!/usr/bin/env bash
# CIS 6.3.3.13 - Ensure audit rules for file deletion are collected
echo "=== CIS 6.3.3.13 - Ensure audit rules for file deletion are collected ==="
echo "-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=1000 -F auid!=unset -F key=delete" > /etc/audit/rules.d/50-delete.rules && augenrules --load
echo "[DONE] Remediation complete"
