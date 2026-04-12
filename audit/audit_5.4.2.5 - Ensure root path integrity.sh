#!/usr/bin/env bash
# CIS 5.4.2.5 - Ensure root path integrity
PASS=0; FAIL=0
echo "=== CIS 5.4.2.5 - Ensure root path integrity ==="
path=$(sudo -Hiu root env 2>/dev/null | grep '^PATH' | cut -d= -f2)
if echo "$path" | grep -Eq '::|:$|(^|:)\.(:|$)'; then echo "[FAIL] Root PATH has ::, trailing : or ."; ((FAIL++))
else echo "[PASS] Root PATH integrity ok"; ((PASS++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
