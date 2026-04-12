#!/usr/bin/env bash
# CIS 5.4.3.1 - Ensure nologin is not listed in /etc/shells
PASS=0; FAIL=0
echo "=== CIS 5.4.3.1 - Ensure nologin is not listed in /etc/shells ==="
if grep -Pqs '/nologin' /etc/shells; then echo "[FAIL] nologin in /etc/shells"; ((FAIL++))
else echo "[PASS] nologin not in /etc/shells"; ((PASS++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
