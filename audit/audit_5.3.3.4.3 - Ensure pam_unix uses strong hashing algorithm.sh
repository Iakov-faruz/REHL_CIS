#!/usr/bin/env bash
# CIS 5.3.3.4.3 - Ensure pam_unix uses strong hashing algorithm
PASS=0; FAIL=0
echo "=== CIS 5.3.3.4.3 - Ensure pam_unix uses strong hashing algorithm ==="
if grep -Pq '^\s*password\s+.*pam_unix\.so\s+.*(sha512|yescrypt)' /etc/pam.d/system-auth /etc/pam.d/password-auth 2>/dev/null; then echo "[PASS] pam_unix uses sha512/yescrypt"; ((PASS++))
else echo "[FAIL] pam_unix missing strong algorithm"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
