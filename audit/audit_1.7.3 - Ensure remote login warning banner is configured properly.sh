#!/usr/bin/env bash
# CIS 1.7.3 - Ensure remote login warning banner is configured properly (Audit)

echo "=== Checking /etc/issue.net ==="
if [ -f /etc/issue.net ]; then
    CONTENT=$(cat /etc/issue.net)
    if echo "$CONTENT" | grep -Piq '(\\v|\\r|\\m|\\s|\bLinux\b)'; then
        echo " - FAIL: /etc/issue.net contains OS information disclosure characters"
        echo " - Current content:"
        cat /etc/issue.net
    elif [ -z "$CONTENT" ]; then
        echo " - WARN: /etc/issue.net is empty - a banner should be configured"
    else
        echo " - PASS: /etc/issue.net is configured without OS info disclosure"
    fi
else
    echo " - FAIL: /etc/issue.net does not exist"
fi
