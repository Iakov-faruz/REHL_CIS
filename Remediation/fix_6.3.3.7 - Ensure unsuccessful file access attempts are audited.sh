#!/usr/bin/env bash
# CIS 6.3.3.7 - Ensure unsuccessful file access attempts are audited
echo "=== CIS 6.3.3.7 - Ensure unsuccessful file access attempts are audited ==="
echo "-a always,exit -F arch=b64 -S creat,open,openat,truncate,ftruncate -F exit=-EACCES -F auid>=1000 -F auid!=unset -k access" > /etc/audit/rules.d/50-access.rules
echo "[DONE] Remediation complete"
