#!/usr/bin/env bash
# CIS 5.3.3.4.4 - Ensure pam_unix includes use_authtok
echo "=== CIS 5.3.3.4.4 - Ensure pam_unix includes use_authtok ==="
for f in system-auth password-auth; do sed -ri 's/(^\s*password\s+.*pam_unix\.so\s+.*)$/\1 use_authtok/' /etc/pam.d/$f 2>/dev/null; done
echo "[DONE] Remediation complete"
