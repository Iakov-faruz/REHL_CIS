#!/usr/bin/env bash
# CIS 5.1.13 - Ensure sshd IgnoreRhosts is enabled (Audit)

echo "=== CIS 5.1.13 - Auditing IgnoreRhosts ==="
RESULT=$(sshd -T 2>/dev/null | grep ignorerhosts)
VALUE=$(echo "$RESULT" | awk '{print $2}')

if [ "$VALUE" = "yes" ]; then
    echo " - PASS: IgnoreRhosts is set to yes"
else
    echo " - FAIL: IgnoreRhosts is '$VALUE' (should be 'yes')"
fi
