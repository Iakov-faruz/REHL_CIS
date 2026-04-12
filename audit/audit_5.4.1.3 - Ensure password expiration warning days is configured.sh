#!/usr/bin/env bash
# CIS 5.4.1.3 - Ensure password expiration warning days is configured
PASS=0; FAIL=0
echo "=== CIS 5.4.1.3 - Ensure password expiration warning days is configured ==="
pwa=$(awk '/^\s*PASS_WARN_AGE/{print $2}' /etc/login.defs)
if [ -n "$pwa" ] && [ "$pwa" -ge 7 ]; then echo "[PASS] PASS_WARN_AGE is $pwa"; ((PASS++))
else echo "[FAIL] PASS_WARN_AGE < 7 or missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
