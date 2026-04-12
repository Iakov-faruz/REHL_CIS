#!/usr/bin/env bash
# CIS 5.3.3.2.5 - Ensure password creation requirements are configured - maxsequence
PASS=0; FAIL=0
echo "=== CIS 5.3.3.2.5 - Ensure password creation requirements are configured - maxsequence ==="
res=$(grep -Psi '^\s*maxsequence\s*=\s*[1-3]' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] maxsequence configured"; ((PASS++))
else echo "[FAIL] maxsequence not configured (1-3)"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
