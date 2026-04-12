#!/usr/bin/env bash
# CIS 5.3.3.2.2 - Ensure password creation requirements are configured - minlen
echo "=== CIS 5.3.3.2.2 - Ensure password creation requirements are configured - minlen ==="
echo "minlen = 14" > /etc/security/pwquality.conf.d/50-pwquality-minlen.conf
echo "[DONE] Remediation complete"
