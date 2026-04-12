#!/usr/bin/env bash
# CIS 6.3.3.18 - Ensure audit rules for usermod use are collected
echo "=== CIS 6.3.3.18 - Ensure audit rules for usermod use are collected ==="
echo "-a always,exit -F path=/usr/sbin/usermod -F perm=x -F auid>=1000 -F auid!=unset -k usermod" > /etc/audit/rules.d/50-usermod.rules && augenrules --load
echo "[DONE] Remediation complete"
