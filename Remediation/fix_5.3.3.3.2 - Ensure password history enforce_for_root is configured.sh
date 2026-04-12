#!/usr/bin/env bash
# CIS 5.3.3.3.2 - Ensure password history enforce_for_root is configured
echo "=== CIS 5.3.3.3.2 - Ensure password history enforce_for_root is configured ==="
if ! grep -Piq '^\s*enforce_for_root' /etc/security/pwhistory.conf 2>/dev/null; then echo "enforce_for_root" >> /etc/security/pwhistory.conf; fi
echo "[DONE] Remediation complete"
