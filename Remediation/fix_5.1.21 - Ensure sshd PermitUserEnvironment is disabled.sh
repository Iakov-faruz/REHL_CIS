#!/usr/bin/env bash
# CIS 5.1.21 - Ensure sshd PermitUserEnvironment is disabled (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.21 - Setting PermitUserEnvironment ==="
if grep -Piq '^\h*PermitUserEnvironment\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(PermitUserEnvironment\h+).*/PermitUserEnvironment no/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h/i PermitUserEnvironment no' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^PermitUserEnvironment" "$SSHD_CONFIG" || echo "PermitUserEnvironment no" >> "$SSHD_CONFIG"
fi
echo " - Set PermitUserEnvironment no"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
