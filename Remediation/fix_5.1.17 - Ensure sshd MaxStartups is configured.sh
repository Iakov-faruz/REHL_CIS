#!/usr/bin/env bash
# CIS 5.1.17 - Ensure sshd MaxStartups is configured (Remediation)
SSHD_CONFIG="/etc/ssh/sshd_config"
echo "=== CIS 5.1.17 - Setting MaxStartups ==="
if grep -Piq '^\h*MaxStartups\h' "$SSHD_CONFIG"; then
    sed -ri 's/^\h*(MaxStartups\h+).*/MaxStartups 10:30:60/' "$SSHD_CONFIG"
else
    sed -i '/^\h*Include\h/i MaxStartups 10:30:60' "$SSHD_CONFIG" 2>/dev/null
    grep -q "^MaxStartups" "$SSHD_CONFIG" || echo "MaxStartups 10:30:60" >> "$SSHD_CONFIG"
fi
echo " - Set MaxStartups 10:30:60"
systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
