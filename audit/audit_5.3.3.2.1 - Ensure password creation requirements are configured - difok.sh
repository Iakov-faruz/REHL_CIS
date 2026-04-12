#!/usr/bin/env bash
# CIS 5.3.3.2.1 - Ensure password creation requirements are configured - difok
PASS=0; FAIL=0
echo "=== CIS 5.3.3.2.1 - Ensure password creation requirements are configured - difok ==="
res=$(grep -Psi '^\s*difok\s*=\s*([2-9]|[1-9][0-9]+)' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] difok configured"; ((PASS++))
else echo "[FAIL] difok not configured (>= 2)"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
