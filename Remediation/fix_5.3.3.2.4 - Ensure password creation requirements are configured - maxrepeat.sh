#!/usr/bin/env bash
# CIS 5.3.3.2.4 - Ensure password creation requirements are configured - maxrepeat
echo "=== CIS 5.3.3.2.4 - Ensure password creation requirements are configured - maxrepeat ==="
echo "maxrepeat = 3" > /etc/security/pwquality.conf.d/50-pwquality-maxrepeat.conf
echo "[DONE] Remediation complete"
