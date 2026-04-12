#!/usr/bin/env bash
# CIS 6.3.2.3 - Ensure audit system warns when full
echo "=== CIS 6.3.2.3 - Ensure audit system warns when full ==="
sed -ri 's/^\s*space_left_action\s*=.*$/space_left_action = email/' /etc/audit/auditd.conf || echo "space_left_action = email" >> /etc/audit/auditd.conf
echo "[DONE] Remediation complete"
