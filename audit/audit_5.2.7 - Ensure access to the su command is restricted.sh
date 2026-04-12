#!/usr/bin/env bash
# CIS 5.2.7 - Ensure access to the su command is restricted (Audit)

echo "=== CIS 5.2.7 - Auditing su command restriction ==="
RESULT=$(grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$' /etc/pam.d/su 2>/dev/null)
if [ -n "$RESULT" ]; then
    echo " - PASS: pam_wheel.so is configured in /etc/pam.d/su:"
    echo "   $RESULT"
    # Extract the group name and check it's empty
    GROUP_NAME=$(echo "$RESULT" | grep -oP 'group=\K\S+')
    if [ -n "$GROUP_NAME" ]; then
        MEMBERS=$(grep "^${GROUP_NAME}:" /etc/group 2>/dev/null | cut -d: -f4)
        if [ -z "$MEMBERS" ]; then
            echo " - PASS: Group '$GROUP_NAME' has no users (as expected)"
        else
            echo " - FAIL: Group '$GROUP_NAME' has users: $MEMBERS (should be empty)"
        fi
    fi
else
    echo " - FAIL: pam_wheel.so not configured in /etc/pam.d/su"
fi
