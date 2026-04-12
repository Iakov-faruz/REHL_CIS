#!/usr/bin/env bash
# CIS 1.7.1 - Ensure message of the day is configured properly (Audit)

echo "=== Checking /etc/motd ==="
if [ -f /etc/motd ]; then
    CONTENT=$(cat /etc/motd)
    # Check for OS info disclosure
    if echo "$CONTENT" | grep -Piq '(\\v|\\r|\\m|\\s|\bLinux\b)'; then
        echo " - FAIL: /etc/motd contains OS information that should be removed"
        echo " - Current content:"
        cat /etc/motd
    elif [ -z "$CONTENT" ] || [ "$(echo "$CONTENT" | grep -c .)" -eq 0 ]; then
        echo " - WARN: /etc/motd is empty - a banner should be configured"
    else
        echo " - PASS: /etc/motd is configured and does not appear to contain OS info"
    fi
else
    echo " - WARN: /etc/motd does not exist"
fi
