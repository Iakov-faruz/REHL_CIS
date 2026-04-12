#!/usr/bin/env bash
# CIS 5.3.3.4.1 - Ensure pam_unix does not include nullok
echo "=== CIS 5.3.3.4.1 - Ensure pam_unix does not include nullok ==="
authselect enable-feature without-nullok; authselect apply-changes; for f in system-auth password-auth; do sed -ri 's/\bnullok\b//' /etc/pam.d/$f 2>/dev/null; done
echo "[DONE] Remediation complete"
