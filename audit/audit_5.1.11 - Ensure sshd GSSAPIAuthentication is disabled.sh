#!/usr/bin/env bash
# CIS 5.1.11 - Ensure sshd GSSAPIAuthentication is disabled (Audit)

echo "=== CIS 5.1.11 - Auditing GSSAPIAuthentication ==="
RESULT=$(sshd -T 2>/dev/null | grep gssapiauthentication)
VALUE=$(echo "$RESULT" | awk '{print $2}')

if [ "$VALUE" = "no" ]; then
    echo " - PASS: GSSAPIAuthentication is set to no"
else
    echo " - FAIL: GSSAPIAuthentication is '$VALUE' (should be 'no')"
fi
