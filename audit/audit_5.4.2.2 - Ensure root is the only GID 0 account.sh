#!/usr/bin/env bash
# CIS 5.4.2.2 - Ensure root is the only GID 0 account
PASS=0; FAIL=0
echo "=== CIS 5.4.2.2 - Ensure root is the only GID 0 account ==="
if [ "$(awk -F: '($1 !~ /^(sync|shutdown|halt|operator)/ && $4=="0") {print $1}' /etc/passwd)" = "root" ]; then echo "[PASS] Only root has primary GID 0"; ((PASS++))
else echo "[FAIL] Other accounts have primary GID 0"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
