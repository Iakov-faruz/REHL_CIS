#!/usr/bin/env bash
# CIS 5.1.20 - Ensure sshd PermitRootLogin is disabled (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.20 - Setting PermitRootLogin ==="
if grep -Piq '^\h*PermitRootLogin\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(PermitRootLogin\h+).*/PermitRootLogin no/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h\|^\h*Match\h/i PermitRootLogin no' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^PermitRootLogin" "$SSHD_CONFIG" || echo "PermitRootLogin no" >> "$SSHD_CONFIG"
fi
echo " - Set PermitRootLogin no"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
