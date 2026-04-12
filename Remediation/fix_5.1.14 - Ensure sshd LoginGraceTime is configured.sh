#!/usr/bin/env bash
# CIS 5.1.14 - Ensure sshd LoginGraceTime is configured (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.14 - Setting LoginGraceTime ==="
if grep -Piq '^\h*LoginGraceTime\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(LoginGraceTime\h+).*/LoginGraceTime 60/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h/i LoginGraceTime 60' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^LoginGraceTime" "$SSHD_CONFIG" || echo "LoginGraceTime 60" >> "$SSHD_CONFIG"
fi
echo " - Set LoginGraceTime 60"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
