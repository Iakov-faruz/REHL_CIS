#!/usr/bin/env bash
# CIS 6.3.3.10 - Ensure audit rules for file system mounts are collected
echo "=== CIS 6.3.3.10 - Ensure audit rules for file system mounts are collected ==="
echo "-a always,exit -F arch=b64 -S mount -F auid>=1000 -F auid!=unset -k mounts" > /etc/audit/rules.d/50-mounts.rules && augenrules --load
echo "[DONE] Remediation complete"
