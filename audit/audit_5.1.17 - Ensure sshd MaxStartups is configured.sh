#!/usr/bin/env bash
# CIS 5.1.17 - Ensure sshd MaxStartups is configured (Audit)

echo "=== CIS 5.1.17 - Auditing MaxStartups ==="
RESULT=$(sshd -T 2>/dev/null | awk '$1 ~ /^\s*maxstartups/{split($2, a, ":"){if(a[1] > 10 || a[2] > 30 || a[3] > 60) print $0}}')
if [ -n "$RESULT" ]; then
    echo " - FAIL: MaxStartups is less restrictive than 10:30:60"
    echo "   $RESULT"
else
    echo " - PASS: MaxStartups is 10:30:60 or more restrictive"
    sshd -T 2>/dev/null | grep maxstartups
fi
