#!/usr/bin/env bash
# CIS 5.1.18 - Ensure sshd MaxSessions is configured (Audit)

echo "=== CIS 5.1.18 - Auditing MaxSessions ==="
VALUE=$(sshd -T 2>/dev/null | grep -i maxsessions | awk '{print $2}')

if [ -n "$VALUE" ] && [ "$VALUE" -le 10 ] 2>/dev/null; then
    echo " - PASS: MaxSessions is $VALUE (10 or less)"
else
    echo " - FAIL: MaxSessions is '$VALUE' (should be 10 or less)"
fi

# Additional check for overrides
OVERRIDE=$(grep -Psi -- '^\h*MaxSessions\h+\"?(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf 2>/dev/null)
if [ -n "$OVERRIDE" ]; then
    echo " - FAIL: MaxSessions override found:"
    echo "   $OVERRIDE"
fi
