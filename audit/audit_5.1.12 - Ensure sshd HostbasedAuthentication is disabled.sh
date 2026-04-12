#!/usr/bin/env bash
# CIS 5.1.12 - Ensure sshd HostbasedAuthentication is disabled (Audit)

echo "=== CIS 5.1.12 - Auditing HostbasedAuthentication ==="
RESULT=$(sshd -T 2>/dev/null | grep hostbasedauthentication)
VALUE=$(echo "$RESULT" | awk '{print $2}')

if [ "$VALUE" = "no" ]; then
    echo " - PASS: HostbasedAuthentication is set to no"
else
    echo " - FAIL: HostbasedAuthentication is '$VALUE' (should be 'no')"
fi
