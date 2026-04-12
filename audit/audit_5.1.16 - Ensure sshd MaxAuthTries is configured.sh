#!/usr/bin/env bash
# CIS 5.1.16 - Ensure sshd MaxAuthTries is configured (Audit)

echo "=== CIS 5.1.16 - Auditing MaxAuthTries ==="
RESULT=$(sshd -T 2>/dev/null | grep maxauthtries)
VALUE=$(echo "$RESULT" | awk '{print $2}')

if [ -n "$VALUE" ] && [ "$VALUE" -le 4 ] 2>/dev/null; then
    echo " - PASS: MaxAuthTries is $VALUE (4 or less)"
else
    echo " - FAIL: MaxAuthTries is '$VALUE' (should be 4 or less)"
fi
