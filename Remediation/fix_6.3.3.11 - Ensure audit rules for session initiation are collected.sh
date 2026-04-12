#!/usr/bin/env bash
# CIS 6.3.3.11 - Ensure audit rules for session initiation are collected
echo "=== CIS 6.3.3.11 - Ensure audit rules for session initiation are collected ==="
echo "-w /var/run/utmp -p wa -k session" > /etc/audit/rules.d/50-session.rules && augenrules --load
echo "[DONE] Remediation complete"
