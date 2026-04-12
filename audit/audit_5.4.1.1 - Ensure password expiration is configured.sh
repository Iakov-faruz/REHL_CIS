#!/usr/bin/env bash
# CIS 5.4.1.1 - Ensure password expiration is configured
PASS=0; FAIL=0
echo "=== CIS 5.4.1.1 - Ensure password expiration is configured ==="
pmd=$(awk '/^\s*PASS_MAX_DAYS/{print $2}' /etc/login.defs)
if [ -n "$pmd" ] && [ "$pmd" -le 365 ] && [ "$pmd" -gt 0 ]; then echo "[PASS] PASS_MAX_DAYS is $pmd"; ((PASS++))
else echo "[FAIL] PASS_MAX_DAYS > 365 or missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
