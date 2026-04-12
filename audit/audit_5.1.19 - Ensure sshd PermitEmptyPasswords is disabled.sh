#!/usr/bin/env bash
# CIS 5.1.19 - Ensure sshd PermitEmptyPasswords is disabled (Audit)

echo "=== CIS 5.1.19 - Auditing PermitEmptyPasswords ==="
VALUE=$(sshd -T 2>/dev/null | grep permitemptypasswords | awk '{print $2}')

if [ "$VALUE" = "no" ]; then
    echo " - PASS: PermitEmptyPasswords is set to no"
else
    echo " - FAIL: PermitEmptyPasswords is '$VALUE' (should be 'no')"
fi
