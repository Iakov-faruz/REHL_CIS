#!/usr/bin/env bash
# CIS 5.1.20 - Ensure sshd PermitRootLogin is disabled (Audit)

echo "=== CIS 5.1.20 - Auditing PermitRootLogin ==="
VALUE=$(sshd -T 2>/dev/null | grep permitrootlogin | awk '{print $2}')

if [ "$VALUE" = "no" ]; then
    echo " - PASS: PermitRootLogin is set to no"
else
    echo " - FAIL: PermitRootLogin is '$VALUE' (should be 'no')"
fi
