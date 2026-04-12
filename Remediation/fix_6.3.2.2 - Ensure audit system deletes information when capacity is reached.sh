#!/usr/bin/env bash
# CIS 6.3.2.2 - Ensure audit system deletes information when capacity is reached
echo "=== CIS 6.3.2.2 - Ensure audit system deletes information when capacity is reached ==="
sed -ri 's/^\s*max_log_file_action\s*=.*$/max_log_file_action = keep_logs/' /etc/audit/auditd.conf || echo "max_log_file_action = keep_logs" >> /etc/audit/auditd.conf
echo "[DONE] Remediation complete"
