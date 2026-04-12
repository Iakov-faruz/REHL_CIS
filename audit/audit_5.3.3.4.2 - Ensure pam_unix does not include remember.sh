#!/usr/bin/env bash
# CIS 5.3.3.4.2 - Ensure pam_unix does not include remember
PASS=0; FAIL=0
echo "=== CIS 5.3.3.4.2 - Ensure pam_unix does not include remember ==="
if grep -Pi '\s*password\s+.*pam_unix\.so' /etc/pam.d/system-auth /etc/pam.d/password-auth 2>/dev/null | grep -qi 'remember='; then echo "[FAIL] pam_unix includes remember"; ((FAIL++))
else echo "[PASS] pam_unix does not include remember"; ((PASS++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
