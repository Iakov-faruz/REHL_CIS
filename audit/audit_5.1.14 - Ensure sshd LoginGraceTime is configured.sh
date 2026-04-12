#!/usr/bin/env bash
# CIS 5.1.14 - Ensure sshd LoginGraceTime is configured (Audit)

echo "=== CIS 5.1.14 - Auditing LoginGraceTime ==="
RESULT=$(sshd -T 2>/dev/null | grep logingracetime)
VALUE=$(echo "$RESULT" | awk '{print $2}')

if [ -n "$VALUE" ] && [ "$VALUE" -ge 1 ] && [ "$VALUE" -le 60 ] 2>/dev/null; then
    echo " - PASS: LoginGraceTime is $VALUE (between 1 and 60)"
else
    echo " - FAIL: LoginGraceTime is '$VALUE' (should be between 1 and 60)"
fi
