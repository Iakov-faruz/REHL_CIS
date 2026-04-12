#!/usr/bin/env bash
# CIS 5.1.7 - Ensure sshd access is configured (Audit)
# Verify that at least one of AllowUsers/AllowGroups/DenyUsers/DenyGroups is set

echo "=== CIS 5.1.7 - Auditing sshd access ==="
RESULT=$(sshd -T 2>/dev/null | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+')
if [ -n "$RESULT" ]; then
    echo " - PASS: SSH access control is configured:"
    echo "$RESULT" | while read -r line; do
        echo "   $line"
    done
    echo " - Review the list(s) to ensure they follow local site policy"
else
    echo " - FAIL: No AllowUsers, AllowGroups, DenyUsers, or DenyGroups configured"
    echo " - At least one of these parameters should be set to restrict SSH access"
fi
