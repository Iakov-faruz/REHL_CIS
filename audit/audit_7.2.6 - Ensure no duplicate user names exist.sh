#!/usr/bin/env bash
# CIS 7.2.6 - Ensure no duplicate user names exist
PASS=0; FAIL=0
echo "=== CIS 7.2.6 - Ensure no duplicate user names exist ==="
dup=$(cut -f1 -d":" /etc/passwd | sort | uniq -d)
if [ -z "$dup" ]; then echo "[PASS] No duplicate user names"; ((PASS++))
else echo "[FAIL] Duplicate user names: $dup"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
