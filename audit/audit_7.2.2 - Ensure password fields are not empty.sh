#!/usr/bin/env bash
# CIS 7.2.2 - Ensure password fields are not empty
PASS=0; FAIL=0
echo "=== CIS 7.2.2 - Empty Password Fields ==="
empty=$(awk -F: '($2 == "") {print $1}' /etc/shadow)
if [ -z "$empty" ]; then
    echo "[PASS] No accounts have empty password fields"; ((PASS++))
else
    echo "[FAIL] Accounts with empty passwords: $empty"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
