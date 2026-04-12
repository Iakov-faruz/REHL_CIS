#!/usr/bin/env bash
# CIS 5.3.3.1.1 - Ensure password lockout deny is configured
PASS=0; FAIL=0
echo "=== CIS 5.3.3.1.1 - Ensure password lockout deny is configured ==="
res=$(grep -Pis '^\s*deny\s*=\s*[1-5]' /etc/security/faillock.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] faillock deny configured"; ((PASS++))
else echo "[FAIL] faillock deny not configured (<= 5)"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
