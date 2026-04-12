#!/usr/bin/env bash
# CIS 5.1.22 - Ensure sshd UsePAM is enabled (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.22 - Setting UsePAM ==="
if grep -Piq '^\h*UsePAM\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(UsePAM\h+).*/UsePAM yes/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h/i UsePAM yes' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^UsePAM" "$SSHD_CONFIG" || echo "UsePAM yes" >> "$SSHD_CONFIG"
fi
echo " - Set UsePAM yes"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
