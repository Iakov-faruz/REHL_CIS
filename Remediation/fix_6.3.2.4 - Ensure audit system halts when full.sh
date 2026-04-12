#!/usr/bin/env bash
# CIS 6.3.2.4 - Ensure audit system halts when full
echo "=== CIS 6.3.2.4 - Ensure audit system halts when full ==="
sed -ri 's/^\s*admin_space_left_action\s*=.*$/admin_space_left_action = halt/' /etc/audit/auditd.conf || echo "admin_space_left_action = halt" >> /etc/audit/auditd.conf
echo "[DONE] Remediation complete"
