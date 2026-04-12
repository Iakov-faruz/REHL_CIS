#!/usr/bin/env bash
# CIS 5.4.2.6 - Ensure root user umask is configured
PASS=0; FAIL=0
echo "=== CIS 5.4.2.6 - Ensure root user umask is configured ==="
bad=$(grep -Psi 'umask\s+0?([0-7][0-7][01][0-7]|[0-7][01][0-7])' /root/.bash_profile /root/.bashrc 2>/dev/null)
if [ -z "$bad" ]; then echo "[PASS] Root umask not too permissive"; ((PASS++))
else echo "[FAIL] Root umask too permissive"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
