#!/usr/bin/env bash
# CIS 5.3.3.2.6 - Ensure password creation requirements are configured - dictcheck
echo "=== CIS 5.3.3.2.6 - Ensure password creation requirements are configured - dictcheck ==="
sed -ri 's/^\s*dictcheck\s*=\s*0/# dictcheck = 0/' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null
echo "[DONE] Remediation complete"
