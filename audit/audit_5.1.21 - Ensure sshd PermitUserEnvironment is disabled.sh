#!/usr/bin/env bash
# CIS 5.1.21 - Ensure sshd PermitUserEnvironment is disabled (Audit)

echo "=== CIS 5.1.21 - Auditing PermitUserEnvironment ==="
VALUE=$(sshd -T 2>/dev/null | grep permituserenvironment | awk '{print $2}')

if [ "$VALUE" = "no" ]; then
    echo " - PASS: PermitUserEnvironment is set to no"
else
    echo " - FAIL: PermitUserEnvironment is '$VALUE' (should be 'no')"
fi
