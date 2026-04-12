#!/usr/bin/env bash
# CIS 5.1.19 - Ensure sshd PermitEmptyPasswords is disabled (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.19 - Setting PermitEmptyPasswords ==="
if grep -Piq '^\h*PermitEmptyPasswords\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(PermitEmptyPasswords\h+).*/PermitEmptyPasswords no/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h\|^\h*Match\h/i PermitEmptyPasswords no' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^PermitEmptyPasswords" "$SSHD_CONFIG" || echo "PermitEmptyPasswords no" >> "$SSHD_CONFIG"
fi
echo " - Set PermitEmptyPasswords no"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
