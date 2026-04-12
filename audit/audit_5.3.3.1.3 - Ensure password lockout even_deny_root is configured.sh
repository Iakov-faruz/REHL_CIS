#!/usr/bin/env bash
# CIS 5.3.3.1.3 - Ensure password lockout even_deny_root is configured
PASS=0; FAIL=0
echo "=== CIS 5.3.3.1.3 - Ensure password lockout even_deny_root is configured ==="
res=$(grep -Pis '^\s*even_deny_root' /etc/security/faillock.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] faillock even_deny_root configured"; ((PASS++))
else echo "[FAIL] faillock even_deny_root not configured"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
