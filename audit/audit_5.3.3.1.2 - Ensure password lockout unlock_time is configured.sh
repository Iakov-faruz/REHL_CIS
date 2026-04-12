#!/usr/bin/env bash
# CIS 5.3.3.1.2 - Ensure password lockout unlock_time is configured
PASS=0; FAIL=0
echo "=== CIS 5.3.3.1.2 - Ensure password lockout unlock_time is configured ==="
res=$(grep -Pis '^\s*unlock_time\s*=\s*(900|[1-9][0-9]{3,})' /etc/security/faillock.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] faillock unlock_time configured"; ((PASS++))
else echo "[FAIL] faillock unlock_time not configured (>= 900)"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
