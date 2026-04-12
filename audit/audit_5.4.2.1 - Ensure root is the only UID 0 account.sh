#!/usr/bin/env bash
# CIS 5.4.2.1 - Ensure root is the only UID 0 account
PASS=0; FAIL=0
echo "=== CIS 5.4.2.1 - Ensure root is the only UID 0 account ==="
if [ "$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)" = "root" ]; then echo "[PASS] Only root is UID 0"; ((PASS++))
else echo "[FAIL] Other UID 0 accounts exist"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
