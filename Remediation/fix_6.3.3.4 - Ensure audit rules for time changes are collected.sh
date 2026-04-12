#!/usr/bin/env bash
# CIS 6.3.3.4 - Ensure audit rules for time changes are collected
echo "=== CIS 6.3.3.4 - Ensure audit rules for time changes are collected ==="
echo "-a always,exit -F arch=b64 -S adjtimex,settimeofday -k time-change" > /etc/audit/rules.d/50-time-change.rules && augenrules --load
echo "[DONE] Remediation complete"
