#!/usr/bin/env bash
# CIS 5.2.4 - Ensure users must provide password for escalation (Audit)

echo "=== CIS 5.2.4 - Auditing NOPASSWD ==="
RESULT=$(grep -r "^[^#].*NOPASSWD" /etc/sudoers* 2>/dev/null)
if [ -n "$RESULT" ]; then
    echo " - FAIL: NOPASSWD entries found:"
    echo "$RESULT" | while read -r line; do
        echo "   $line"
    done
else
    echo " - PASS: No NOPASSWD entries found in /etc/sudoers*"
fi
