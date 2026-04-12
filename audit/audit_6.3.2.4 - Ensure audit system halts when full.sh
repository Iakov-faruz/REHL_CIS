#!/usr/bin/env bash
# CIS 6.3.2.4 - Ensure audit system halts when full
PASS=0; FAIL=0
echo "=== CIS 6.3.2.4 - Ensure audit system halts when full ==="
admin=$(awk -F= '/^\s*admin_space_left_action\s*/{print $2}' /etc/audit/auditd.conf | xargs)
if [[ "$admin" =~ ^(halt|single)$ ]]; then echo "[PASS] admin_space_left_action=$admin"; ((PASS++))
else echo "[FAIL] admin_space_left_action=$admin"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
