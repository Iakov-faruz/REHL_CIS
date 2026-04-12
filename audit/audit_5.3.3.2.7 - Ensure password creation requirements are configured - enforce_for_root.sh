#!/usr/bin/env bash
# CIS 5.3.3.2.7 - Ensure password creation requirements are configured - enforce_for_root
PASS=0; FAIL=0
echo "=== CIS 5.3.3.2.7 - Ensure password creation requirements are configured - enforce_for_root ==="
res=$(grep -Psi '^\s*enforce_for_root' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf 2>/dev/null)
if [ -n "$res" ]; then echo "[PASS] enforce_for_root configured"; ((PASS++))
else echo "[FAIL] enforce_for_root not configured"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
