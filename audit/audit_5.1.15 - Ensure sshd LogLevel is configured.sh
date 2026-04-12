#!/usr/bin/env bash
# CIS 5.1.15 - Ensure sshd LogLevel is configured (Audit)

echo "=== CIS 5.1.15 - Auditing LogLevel ==="
RESULT=$(sshd -T 2>/dev/null | grep loglevel)
VALUE=$(echo "$RESULT" | awk '{print $2}')

if [ "$VALUE" = "VERBOSE" ] || [ "$VALUE" = "INFO" ]; then
    echo " - PASS: LogLevel is set to $VALUE"
else
    echo " - FAIL: LogLevel is '$VALUE' (should be 'VERBOSE' or 'INFO')"
fi
