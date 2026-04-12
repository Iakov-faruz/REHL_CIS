#!/usr/bin/env bash
# CIS 5.3.3.2.6 - Ensure password creation requirements are configured - dictcheck
PASS=0; FAIL=0
echo "=== CIS 5.3.3.2.6 - Ensure password creation requirements are configured - dictcheck ==="
res=$(grep -Psi '^\s*dictcheck\s*=\s*0' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null)
if [ -z "$res" ]; then echo "[PASS] dictcheck is not disabled"; ((PASS++))
else echo "[FAIL] dictcheck is disabled"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
