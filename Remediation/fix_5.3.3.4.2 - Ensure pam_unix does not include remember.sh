#!/usr/bin/env bash
# CIS 5.3.3.4.2 - Ensure pam_unix does not include remember
echo "=== CIS 5.3.3.4.2 - Ensure pam_unix does not include remember ==="
for f in system-auth password-auth; do sed -ri 's/\bremember=[0-9]+\b//' /etc/pam.d/$f 2>/dev/null; done
echo "[DONE] Remediation complete"
