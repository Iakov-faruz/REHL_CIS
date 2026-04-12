#!/usr/bin/env bash
# CIS 6.3.3.20 - Ensure audit configuration is immutable
PASS=0; FAIL=0
echo "=== CIS 6.3.3.20 - Ensure audit configuration is immutable ==="
if grep -Pq '^\s*-e\s+2' /etc/audit/rules.d/*.rules; then echo "[PASS] -e 2 is set"; ((PASS++))
else echo "[FAIL] -e 2 is missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
