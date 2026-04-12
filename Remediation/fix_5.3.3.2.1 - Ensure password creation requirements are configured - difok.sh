#!/usr/bin/env bash
# CIS 5.3.3.2.1 - Ensure password creation requirements are configured - difok
echo "=== CIS 5.3.3.2.1 - Ensure password creation requirements are configured - difok ==="
echo "difok = 2" > /etc/security/pwquality.conf.d/50-pwquality-difok.conf
echo "[DONE] Remediation complete"
