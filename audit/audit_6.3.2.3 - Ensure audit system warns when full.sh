#!/usr/bin/env bash
# CIS 6.3.2.3 - Ensure audit system warns when full
PASS=0; FAIL=0
echo "=== CIS 6.3.2.3 - Ensure audit system warns when full ==="
space=$(awk -F= '/^\s*space_left_action\s*/{print $2}' /etc/audit/auditd.conf | xargs)
if [[ "$space" =~ ^(email|exec|single|halt)$ ]]; then echo "[PASS] space_left_action=$space"; ((PASS++))
else echo "[FAIL] space_left_action=$space"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
