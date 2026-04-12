#!/usr/bin/env bash
# CIS 5.1.8 - Ensure sshd Banner is configured (Remediation)
# Set Banner parameter and configure banner file content

echo "=== CIS 5.1.8 - Configuring sshd Banner ==="

SSHD_CONFIG="/etc/ssh/sshd_config"

# Set Banner parameter in sshd_config
if grep -Piq '^\h*Banner\h' "$SSHD_CONFIG" 2>/dev/null; then
    sed -ri 's/^\h*(Banner\h+).*/Banner \/etc\/issue.net/' "$SSHD_CONFIG"
    echo " - Updated Banner to /etc/issue.net in $SSHD_CONFIG"
else
    sed -ri '0,/^\h*(#\h*)?Banner\h/{ s/^\h*(#\h*)?Banner\h.*/Banner \/etc\/issue.net/ }' "$SSHD_CONFIG" 2>/dev/null
    if ! grep -q "^Banner" "$SSHD_CONFIG"; then
        # Insert before any Include or Match statements
        sed -i '/^\h*Include\h\|^\h*Match\h/i Banner /etc/issue.net' "$SSHD_CONFIG" 2>/dev/null
        if ! grep -q "^Banner" "$SSHD_CONFIG"; then
            echo "Banner /etc/issue.net" >> "$SSHD_CONFIG"
        fi
    fi
    echo " - Added Banner /etc/issue.net to $SSHD_CONFIG"
fi

# Configure banner file content
printf '%s\n' "Authorized users only. All activity may be monitored and reported." > /etc/issue.net
echo " - Updated /etc/issue.net with warning banner"

systemctl reload sshd 2>/dev/null
echo " - Reloaded sshd"
