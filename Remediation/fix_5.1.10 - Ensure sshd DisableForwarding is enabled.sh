#!/usr/bin/env bash
# CIS 5.1.10 - Ensure sshd DisableForwarding is enabled (Remediation)

echo "=== CIS 5.1.10 - Setting DisableForwarding ==="

SSHD_CONFIG="/etc/ssh/sshd_config"

if grep -Piq '^\h*DisableForwarding\h' "$SSHD_CONFIG" 2>/dev/null; then
    sed -ri 's/^\h*(DisableForwarding\h+).*/DisableForwarding yes/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h/i DisableForwarding yes' "$SSHD_CONFIG" 2>/dev/null
    if ! grep -q "^DisableForwarding" "$SSHD_CONFIG"; then
        echo "DisableForwarding yes" >> "$SSHD_CONFIG"
    fi
fi
echo " - Set DisableForwarding yes"

systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
