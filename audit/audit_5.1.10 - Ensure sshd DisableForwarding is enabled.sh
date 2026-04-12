#!/usr/bin/env bash
# CIS 5.1.10 - Ensure sshd DisableForwarding is enabled (Audit)

echo "=== CIS 5.1.10 - Auditing DisableForwarding ==="
RESULT=$(sshd -T 2>/dev/null | grep -i disableforwarding)
VALUE=$(echo "$RESULT" | awk '{print $2}')

if [ "$VALUE" = "yes" ]; then
    echo " - PASS: DisableForwarding is set to yes"
else
    echo " - FAIL: DisableForwarding is set to '$VALUE' (should be 'yes')"
fi
