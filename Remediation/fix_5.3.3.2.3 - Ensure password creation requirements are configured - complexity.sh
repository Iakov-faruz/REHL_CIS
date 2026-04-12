#!/usr/bin/env bash
# CIS 5.3.3.2.3 - Ensure password creation requirements are configured - complexity
echo "=== CIS 5.3.3.2.3 - Ensure password creation requirements are configured - complexity ==="
echo "minclass = 4" > /etc/security/pwquality.conf.d/50-pwquality-complexity.conf
echo "[DONE] Remediation complete"
