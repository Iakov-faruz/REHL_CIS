#!/usr/bin/env bash
# CIS 5.4.1.2 - Ensure minimum password days is configured
PASS=0; FAIL=0
echo "=== CIS 5.4.1.2 - Ensure minimum password days is configured ==="
pmind=$(awk '/^\s*PASS_MIN_DAYS/{print $2}' /etc/login.defs)
if [ -n "$pmind" ] && [ "$pmind" -ge 1 ]; then echo "[PASS] PASS_MIN_DAYS is $pmind"; ((PASS++))
else echo "[FAIL] PASS_MIN_DAYS < 1 or missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
