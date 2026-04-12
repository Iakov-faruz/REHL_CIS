#!/usr/bin/env bash
# CIS 7.1.11 - Ensure world writable files and directories are secured
PASS=0; FAIL=0
echo "=== CIS 7.1.11 - World Writable Files ==="
ww_count=$(find / -xdev \( -type f -o -type d \) -perm -0002 ! -path "/proc/*" ! -path "/sys/*" ! -path "/run/user/*" 2>/dev/null | head -20 | wc -l)
if [ "$ww_count" -eq 0 ]; then
    echo "[PASS] No world writable files/directories found"; ((PASS++))
else
    echo "[FAIL] Found $ww_count+ world writable items"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
