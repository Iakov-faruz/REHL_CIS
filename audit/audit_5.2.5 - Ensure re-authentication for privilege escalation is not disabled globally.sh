#!/usr/bin/env bash
# CIS 5.2.5 - Ensure re-authentication for privilege escalation is not disabled globally (Audit)

echo "=== CIS 5.2.5 - Auditing !authenticate ==="
RESULT=$(grep -r "^[^#].*\!authenticate" /etc/sudoers* 2>/dev/null)
if [ -n "$RESULT" ]; then
    echo " - FAIL: !authenticate entries found:"
    echo "$RESULT" | while read -r line; do
        echo "   $line"
    done
else
    echo " - PASS: No !authenticate entries found in /etc/sudoers*"
fi
