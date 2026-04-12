#!/usr/bin/env bash
# CIS 1.7.2 - Ensure local login warning banner is configured properly (Audit)

echo "=== Checking /etc/issue ==="
if [ -f /etc/issue ]; then
    CONTENT=$(cat /etc/issue)
    if echo "$CONTENT" | grep -Piq '(\\v|\\r|\\m|\\s|\bLinux\b)'; then
        echo " - FAIL: /etc/issue contains OS information disclosure characters"
        echo " - Current content:"
        cat /etc/issue
    elif [ -z "$CONTENT" ]; then
        echo " - WARN: /etc/issue is empty - a banner should be configured"
    else
        echo " - PASS: /etc/issue is configured without OS info disclosure"
    fi
else
    echo " - FAIL: /etc/issue does not exist"
fi
