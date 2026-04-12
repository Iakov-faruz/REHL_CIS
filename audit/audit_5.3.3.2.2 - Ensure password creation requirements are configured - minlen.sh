#!/usr/bin/env bash
# CIS 5.3.3.2.2 - Ensure password creation requirements are configured - minlen
PASS=0; FAIL=0
echo "=== CIS 5.3.3.2.2 - Ensure password creation requirements are configured - minlen ==="
res=$(grep -Psi '^\s*minlen\s*=\s*(1[4-9]|[2-9][0-9])' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] minlen configured"; ((PASS++))
else echo "[FAIL] minlen not configured (>= 14)"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
