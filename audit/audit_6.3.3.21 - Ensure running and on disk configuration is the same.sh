#!/usr/bin/env bash
# CIS 6.3.3.21 - Ensure running and on disk configuration is the same
PASS=0; FAIL=0
echo "=== CIS 6.3.3.21 - Ensure running and on disk configuration is the same ==="
res=$(augenrules --check 2>/dev/null)
if echo "$res" | grep -q 'No change'; then echo "[PASS] No drift"; ((PASS++))
else echo "[FAIL] Configuration drift detected"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
