#!/usr/bin/env bash
# CIS 5.1.22 - Ensure sshd UsePAM is enabled (Audit)

echo "=== CIS 5.1.22 - Auditing UsePAM ==="
VALUE=$(sshd -T 2>/dev/null | grep -i usepam | awk '{print $2}')

if [ "$VALUE" = "yes" ]; then
    echo " - PASS: UsePAM is set to yes"
else
    echo " - FAIL: UsePAM is '$VALUE' (should be 'yes')"
fi
