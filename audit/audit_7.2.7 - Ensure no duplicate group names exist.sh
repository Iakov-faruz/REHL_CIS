#!/usr/bin/env bash
# CIS 7.2.7 - Ensure no duplicate group names exist
PASS=0; FAIL=0
echo "=== CIS 7.2.7 - Ensure no duplicate group names exist ==="
dup=$(cut -f1 -d":" /etc/group | sort | uniq -d)
if [ -z "$dup" ]; then echo "[PASS] No duplicate group names"; ((PASS++))
else echo "[FAIL] Duplicate group names: $dup"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
