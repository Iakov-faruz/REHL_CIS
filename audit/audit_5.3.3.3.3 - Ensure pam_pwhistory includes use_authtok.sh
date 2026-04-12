#!/usr/bin/env bash
# CIS 5.3.3.3.3 - Ensure pam_pwhistory includes use_authtok
PASS=0; FAIL=0
echo "=== CIS 5.3.3.3.3 - Ensure pam_pwhistory includes use_authtok ==="
if grep -Pq '^\s*password\s+.*pam_pwhistory\.so\s+.*use_authtok' /etc/pam.d/system-auth /etc/pam.d/password-auth 2>/dev/null; then echo "[PASS] pam_pwhistory use_authtok configured"; ((PASS++))
else echo "[FAIL] pam_pwhistory use_authtok missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
