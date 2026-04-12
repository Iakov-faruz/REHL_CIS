#!/usr/bin/env bash
# CIS 5.3.2.2 - Ensure pam_faillock module is enabled (Audit)

echo "=== CIS 5.3.2.2 - Auditing pam_faillock ==="
RESULT=$(grep -P -- '\bpam_faillock.so\b' /etc/pam.d/{password,system}-auth 2>/dev/null)
if [ -n "$RESULT" ]; then
    echo " - PASS: pam_faillock.so is enabled:"
    echo "$RESULT" | while read -r line; do
        echo "   $line"
    done
else
    echo " - FAIL: pam_faillock.so is NOT enabled in /etc/pam.d/{password,system}-auth"
fi
