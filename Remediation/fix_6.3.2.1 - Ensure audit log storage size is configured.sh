#!/usr/bin/env bash
# CIS 6.3.2.1 - Ensure audit log storage size is configured
echo "=== CIS 6.3.2.1 - Ensure audit log storage size is configured ==="
sed -ri 's/^\s*max_log_file\s*=.*$/max_log_file = 8/' /etc/audit/auditd.conf || echo "max_log_file = 8" >> /etc/audit/auditd.conf
echo "[DONE] Remediation complete"
