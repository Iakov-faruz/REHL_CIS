#!/usr/bin/env bash
# CIS 2.4.1.1 - Ensure cron daemon is enabled and active (Remediation)

echo "=== CIS 2.4.1.1 - Enabling crond ==="
systemctl unmask crond.service 2>/dev/null
systemctl enable crond.service 2>/dev/null
systemctl start crond.service 2>/dev/null
echo " - crond started and enabled"
