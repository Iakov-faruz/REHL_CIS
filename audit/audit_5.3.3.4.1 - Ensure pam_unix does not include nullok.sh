#!/usr/bin/env bash
# CIS 5.3.3.4.1 - Ensure pam_unix does not include nullok
PASS=0; FAIL=0
echo "=== CIS 5.3.3.4.1 - Ensure pam_unix does not include nullok ==="
if grep -P 'pam_unix\.so' /etc/pam.d/system-auth /etc/pam.d/password-auth 2>/dev/null | grep -qi 'nullok'; then echo "[FAIL] pam_unix includes nullok"; ((FAIL++))
else echo "[PASS] pam_unix does not include nullok"; ((PASS++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
