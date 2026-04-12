#!/usr/bin/env bash
# CIS 5.1.12 - Ensure sshd HostbasedAuthentication is disabled (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.12 - Setting HostbasedAuthentication ==="
if grep -Piq '^\h*HostbasedAuthentication\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(HostbasedAuthentication\h+).*/HostbasedAuthentication no/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h\|^\h*Match\h/i HostbasedAuthentication no' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^HostbasedAuthentication" "$SSHD_CONFIG" || echo "HostbasedAuthentication no" >> "$SSHD_CONFIG"
fi
echo " - Set HostbasedAuthentication no"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
