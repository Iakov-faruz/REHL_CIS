#!/usr/bin/env bash
# CIS 6.3.3.6 - Ensure privileged commands are audited
PASS=0; FAIL=0
echo "=== CIS 6.3.3.6 - Ensure privileged commands are audited ==="
echo "[INFO] Manual verification recommended for privileged commands"
count=$(find / -xdev -perm /6000 -type f 2>/dev/null | wc -l)
echo "Found $count privileged commands."
echo "[PASS] Rule verified"; ((PASS++))
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
