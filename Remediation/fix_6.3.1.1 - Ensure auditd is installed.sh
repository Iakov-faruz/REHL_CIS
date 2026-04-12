#!/usr/bin/env bash
# CIS 6.3.1.1 - Ensure auditd is installed
echo "=== CIS 6.3.1.1 - Ensure auditd is installed ==="
dnf install -y audit audit-libs
echo "[DONE] Remediation complete"
