#!/usr/bin/env bash
# CIS 5.3.3.4.3 - Ensure pam_unix uses strong hashing algorithm
echo "=== CIS 5.3.3.4.3 - Ensure pam_unix uses strong hashing algorithm ==="
for f in system-auth password-auth; do sed -ri 's/(^\s*password\s+.*pam_unix\.so\s+.*)$/\1 sha512/' /etc/pam.d/$f 2>/dev/null; done
echo "[DONE] Remediation complete"
