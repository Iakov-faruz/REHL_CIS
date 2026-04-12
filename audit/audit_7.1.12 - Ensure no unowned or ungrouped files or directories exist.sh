#!/usr/bin/env bash
# CIS 7.1.12 - Ensure no unowned or ungrouped files or directories exist
PASS=0; FAIL=0
echo "=== CIS 7.1.12 - Unowned Files ==="
uo_count=$(find / -xdev \( -type f -o -type d \) \( -nouser -o -nogroup \) ! -path "/proc/*" ! -path "/sys/*" 2>/dev/null | head -20 | wc -l)
if [ "$uo_count" -eq 0 ]; then
    echo "[PASS] No unowned/ungrouped files found"; ((PASS++))
else
    echo "[FAIL] Found $uo_count+ unowned items"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
