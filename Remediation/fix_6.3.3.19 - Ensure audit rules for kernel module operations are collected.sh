#!/usr/bin/env bash
# CIS 6.3.3.19 - Ensure audit rules for kernel module operations are collected
echo "=== CIS 6.3.3.19 - Ensure audit rules for kernel module operations are collected ==="
echo "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module,create_module,query_module -F auid>=1000 -F auid!=unset -k kernel_modules" > /etc/audit/rules.d/50-kernel_modules.rules && augenrules --load
echo "[DONE] Remediation complete"
