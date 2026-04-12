#!/usr/bin/env bash
# CIS 6.3.1.2 - Ensure auditd service is enabled and active
echo "=== CIS 6.3.1.2 - Ensure auditd service is enabled and active ==="
systemctl unmask auditd; systemctl enable auditd; systemctl start auditd
echo "[DONE] Remediation complete"
