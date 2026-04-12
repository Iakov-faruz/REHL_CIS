#!/usr/bin/env bash
# CIS 6.3.3.5 - Ensure audit rules for network environment are collected
echo "=== CIS 6.3.3.5 - Ensure audit rules for network environment are collected ==="
echo "-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale" > /etc/audit/rules.d/50-system_locale.rules && augenrules --load
echo "[DONE] Remediation complete"
