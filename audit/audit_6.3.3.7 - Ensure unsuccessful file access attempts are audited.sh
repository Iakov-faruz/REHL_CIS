#!/usr/bin/env bash
# CIS 6.3.3.7 - Ensure unsuccessful file access attempts are audited
PASS=0; FAIL=0
echo "=== CIS 6.3.3.7 - Ensure unsuccessful file access attempts are audited ==="
if grep -Pq 'EACCES|EPERM' /etc/audit/rules.d/*.rules 2>/dev/null; then echo "[PASS] Rules found"; ((PASS++))
else echo "[FAIL] Rules missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
