#!/usr/bin/env bash
# CIS 5.1.13 - Ensure sshd IgnoreRhosts is enabled (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.13 - Setting IgnoreRhosts ==="
if grep -Piq '^\h*IgnoreRhosts\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(IgnoreRhosts\h+).*/IgnoreRhosts yes/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h\|^\h*Match\h/i IgnoreRhosts yes' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^IgnoreRhosts" "$SSHD_CONFIG" || echo "IgnoreRhosts yes" >> "$SSHD_CONFIG"
fi
echo " - Set IgnoreRhosts yes"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
