#!/usr/bin/env bash
# CIS 5.1.18 - Ensure sshd MaxSessions is configured (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.18 - Setting MaxSessions ==="
if grep -Piq '^\h*MaxSessions\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(MaxSessions\h+).*/MaxSessions 10/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h\|^\h*Match\h/i MaxSessions 10' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^MaxSessions" "$SSHD_CONFIG" || echo "MaxSessions 10" >> "$SSHD_CONFIG"
fi
echo " - Set MaxSessions 10"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
