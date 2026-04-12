#!/usr/bin/env bash
# CIS 5.3.3.3.1 - Ensure password history is configured
echo "=== CIS 5.3.3.3.1 - Ensure password history is configured ==="
if grep -q 'remember' /etc/security/pwhistory.conf 2>/dev/null; then sed -ri 's/^\s*remember\s*=.*/remember = 24/' /etc/security/pwhistory.conf; else echo "remember = 24" >> /etc/security/pwhistory.conf; fi
echo "[DONE] Remediation complete"
