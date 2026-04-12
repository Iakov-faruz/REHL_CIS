#!/usr/bin/env bash
# CIS 5.1.16 - Ensure sshd MaxAuthTries is configured (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.16 - Setting MaxAuthTries ==="
if grep -Piq '^\h*MaxAuthTries\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(MaxAuthTries\h+).*/MaxAuthTries 4/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h\|^\h*Match\h/i MaxAuthTries 4' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^MaxAuthTries" "$SSHD_CONFIG" || echo "MaxAuthTries 4" >> "$SSHD_CONFIG"
fi
echo " - Set MaxAuthTries 4"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
