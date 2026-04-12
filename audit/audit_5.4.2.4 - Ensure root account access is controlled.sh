#!/usr/bin/env bash
# CIS 5.4.2.4 - Ensure root account access is controlled
PASS=0; FAIL=0
echo "=== CIS 5.4.2.4 - Ensure root account access is controlled ==="
status=$(passwd -S root 2>/dev/null | awk '{print $2}')
if [[ "$status" =~ ^(P|L)$ ]]; then echo "[PASS] Root access controlled"; ((PASS++))
else echo "[FAIL] Root access not controlled"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
