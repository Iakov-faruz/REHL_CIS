#!/usr/bin/env bash
# CIS 5.4.2.7 - Ensure system accounts do not have a valid login shell
echo "=== CIS 5.4.2.7 - Ensure system accounts do not have a valid login shell ==="
awk -F: '($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && $3<1000 && $7!~/(nologin|false)$/) {system("usermod -s /sbin/nologin "$1)}' /etc/passwd
echo "[DONE] Remediation complete"
