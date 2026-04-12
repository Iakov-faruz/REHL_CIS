#!/usr/bin/env bash
# CIS 5.3.2.4 - Ensure pam_pwhistory module is enabled (Audit)

echo "=== CIS 5.3.2.4 - Auditing pam_pwhistory ==="
RESULT=$(grep -P -- '\bpam_pwhistory\.so\b' /etc/pam.d/{password,system}-auth 2>/dev/null)
if [ -n "$RESULT" ]; then
    echo " - PASS: pam_pwhistory.so is enabled:"
    echo "$RESULT" | while read -r line; do
        echo "   $line"
    done
else
    echo " - FAIL: pam_pwhistory.so is NOT enabled in /etc/pam.d/{password,system}-auth"
fi
