#!/usr/bin/env bash
# CIS 5.1.11 - Ensure sshd GSSAPIAuthentication is disabled (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.11 - Setting GSSAPIAuthentication ==="
if grep -Piq '^\h*GSSAPIAuthentication\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(GSSAPIAuthentication\h+).*/GSSAPIAuthentication no/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h\|^\h*Match\h/i GSSAPIAuthentication no' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^GSSAPIAuthentication" "$SSHD_CONFIG" || echo "GSSAPIAuthentication no" >> "$SSHD_CONFIG"
fi
echo " - Set GSSAPIAuthentication no"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
