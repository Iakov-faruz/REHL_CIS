#!/usr/bin/env bash
# CIS 5.3.2.5 - Ensure pam_faillock.so is enabled
PASS=0; FAIL=0
echo "=== CIS 5.3.2.5 - Ensure pam_faillock.so is enabled ==="
if grep -Pq 'pam_faillock.so' /etc/pam.d/system-auth /etc/pam.d/password-auth 2>/dev/null; then echo "[PASS] pam_faillock enabled"; ((PASS++))
else echo "[FAIL] pam_faillock not enabled"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
