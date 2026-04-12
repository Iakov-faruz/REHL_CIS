#!/usr/bin/env bash
# CIS 3.1.3 - Ensure bluetooth services are not in use (Remediation)
SVC="bluetooth.service"
echo "=== CIS 3.1.3 - Disabling bluetooth ==="
systemctl stop "$SVC" 2>/dev/null
systemctl disable "$SVC" 2>/dev/null
systemctl mask "$SVC" 2>/dev/null
echo " - $SVC stopped, disabled, and masked"
