#!/usr/bin/env bash
# CIS 5.4.1.5 - Ensure inactive password lock is configured
PASS=0; FAIL=0
echo "=== CIS 5.4.1.5 - Ensure inactive password lock is configured ==="
inactive=$(useradd -D | grep INACTIVE | awk -F= '{print $2}')
if [ -n "$inactive" ] && [ "$inactive" -ge 0 ] && [ "$inactive" -le 45 ]; then echo "[PASS] INACTIVE is $inactive"; ((PASS++))
else echo "[FAIL] INACTIVE not between 0-45"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
