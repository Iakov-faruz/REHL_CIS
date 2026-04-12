#!/usr/bin/env bash
# CIS 5.4.3.3 - Ensure default user umask is configured
PASS=0; FAIL=0
echo "=== CIS 5.4.3.3 - Ensure default user umask is configured ==="
if grep -Psq 'umask\s+027' /etc/profile.d/*.sh /etc/profile /etc/bashrc /etc/login.defs 2>/dev/null; then echo "[PASS] Default umask 027 configured"; ((PASS++))
else echo "[FAIL] Default umask 027 missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
