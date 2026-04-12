#!/usr/bin/env bash
# CIS 5.3.3.2.4 - Ensure password creation requirements are configured - maxrepeat
PASS=0; FAIL=0
echo "=== CIS 5.3.3.2.4 - Ensure password creation requirements are configured - maxrepeat ==="
res=$(grep -Psi '^\s*maxrepeat\s*=\s*[1-3]' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] maxrepeat configured"; ((PASS++))
else echo "[FAIL] maxrepeat not configured (1-3)"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
