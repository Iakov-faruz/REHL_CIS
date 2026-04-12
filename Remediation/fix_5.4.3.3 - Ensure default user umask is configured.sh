#!/usr/bin/env bash
# CIS 5.4.3.3 - Ensure default user umask is configured
echo "=== CIS 5.4.3.3 - Ensure default user umask is configured ==="
echo "umask 027" > /etc/profile.d/50-systemwide_umask.sh
echo "[DONE] Remediation complete"
