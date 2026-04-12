#!/usr/bin/env bash
# CIS 5.3.3.1.1 - Ensure password lockout deny is configured
echo "=== CIS 5.3.3.1.1 - Ensure password lockout deny is configured ==="
sed -ri 's/^\s*#?\s*deny\s*=.*$/deny = 5/' /etc/security/faillock.conf
echo "[DONE] Remediation complete"
