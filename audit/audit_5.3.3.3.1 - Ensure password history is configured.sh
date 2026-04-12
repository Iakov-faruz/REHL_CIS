#!/usr/bin/env bash
# CIS 5.3.3.3.1 - Ensure password history is configured
PASS=0; FAIL=0
echo "=== CIS 5.3.3.3.1 - Ensure password history is configured ==="
res=$(grep -Pi '^\s*remember\s*=\s*(2[4-9]|[3-9][0-9]|[1-9][0-9]{2,})' /etc/security/pwhistory.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] pwhistory remember >= 24"; ((PASS++))
else echo "[FAIL] pwhistory remember missing/inadequate"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
