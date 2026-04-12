#!/usr/bin/env bash
# CIS 5.3.3.1.2 - Ensure password lockout unlock_time is configured
echo "=== CIS 5.3.3.1.2 - Ensure password lockout unlock_time is configured ==="
sed -ri 's/^\s*#?\s*unlock_time\s*=.*$/unlock_time = 900/' /etc/security/faillock.conf
echo "[DONE] Remediation complete"
