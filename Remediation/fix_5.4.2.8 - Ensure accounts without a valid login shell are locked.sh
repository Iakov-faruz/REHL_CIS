#!/usr/bin/env bash
# CIS 5.4.2.8 - Ensure accounts without a valid login shell are locked
echo "=== CIS 5.4.2.8 - Ensure accounts without a valid login shell are locked ==="
while IFS= read -r l_user; do passwd -S "$l_user" 2>/dev/null | awk '$2 !~ /^L/ {system ("usermod -L " $1)}'; done < <(awk -F: '($1!="root" && $7~/(nologin|false)$/) {print $1}' /etc/passwd)
echo "[DONE] Remediation complete"
