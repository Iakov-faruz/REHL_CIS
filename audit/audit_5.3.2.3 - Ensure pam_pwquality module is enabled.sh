#!/usr/bin/env bash
# CIS 5.3.2.3 - Ensure pam_pwquality module is enabled (Audit)

echo "=== CIS 5.3.2.3 - Auditing pam_pwquality ==="
RESULT=$(grep -P -- '\bpam_pwquality\.so\b' /etc/pam.d/{password,system}-auth 2>/dev/null)
if [ -n "$RESULT" ]; then
    echo " - PASS: pam_pwquality.so is enabled:"
    echo "$RESULT" | while read -r line; do
        echo "   $line"
    done
else
    echo " - FAIL: pam_pwquality.so is NOT enabled in /etc/pam.d/{password,system}-auth"
fi
