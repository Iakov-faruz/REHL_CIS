#!/usr/bin/env bash
# CIS 5.3.2.1 - Ensure active authselect profile includes pam modules (Audit)

echo "=== CIS 5.3.2.1 - Auditing authselect profile pam modules ==="
PROFILE_PATH="/etc/authselect/$(head -1 /etc/authselect/authselect.conf 2>/dev/null)"
if [ -d "$PROFILE_PATH" ]; then
    echo " - Active profile path: $PROFILE_PATH"
    RESULT=$(grep -P -- '\b(pam_pwquality\.so|pam_pwhistory\.so|pam_faillock\.so|pam_unix\.so)\b' "$PROFILE_PATH"/{system,password}-auth 2>/dev/null)
    if [ -n "$RESULT" ]; then
        echo " - PAM modules found in profile:"
        echo "$RESULT" | while read -r line; do
            echo "   $line"
        done
    else
        echo " - FAIL: Required PAM modules not found in profile templates"
    fi
else
    echo " - FAIL: Cannot determine active authselect profile"
fi
