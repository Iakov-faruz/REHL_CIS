#!/usr/bin/env bash
# CIS 5.3.3.2.3 - Ensure password creation requirements are configured - complexity
PASS=0; FAIL=0
echo "=== CIS 5.3.3.2.3 - Ensure password creation requirements are configured - complexity ==="
res1=$(grep -Psi '^\s*minclass\s*=\s*[4-9]' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null)
res2=$(grep -Psi '^\s*[doluc]credit\s*=\s*-[1-9]' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null | wc -l)
if [ -n "$res1" ] || [ "$res2" -ge 4 ]; then echo "[PASS] complexity configured"; ((PASS++))
else echo "[FAIL] complexity not configured"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
