#!/usr/bin/env bash
# CIS 5.3.3.3.2 - Ensure password history enforce_for_root is configured
PASS=0; FAIL=0
echo "=== CIS 5.3.3.3.2 - Ensure password history enforce_for_root is configured ==="
if grep -Piq '^\s*enforce_for_root' /etc/security/pwhistory.conf 2>/dev/null; then echo "[PASS] pwhistory enforce_for_root configured"; ((PASS++))
else echo "[FAIL] pwhistory enforce_for_root missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
