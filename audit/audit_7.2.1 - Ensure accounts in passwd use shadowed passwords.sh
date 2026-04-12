#!/usr/bin/env bash
# CIS 7.2.1 - Ensure accounts in passwd use shadowed passwords
PASS=0; FAIL=0
echo "=== CIS 7.2.1 - Shadowed Passwords ==="
non_shadow=$(awk -F: '($2 != "x") {print $1}' /etc/passwd)
if [ -z "$non_shadow" ]; then
    echo "[PASS] All accounts use shadowed passwords"; ((PASS++))
else
    echo "[FAIL] Accounts not using shadowed passwords: $non_shadow"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
