#!/usr/bin/env bash
# CIS 6.3.2.2 - Ensure audit system deletes information when capacity is reached
PASS=0; FAIL=0
echo "=== CIS 6.3.2.2 - Ensure audit system deletes information when capacity is reached ==="
if grep -Pq '^\s*max_log_file_action\s*=\s*keep_logs' /etc/audit/auditd.conf; then
echo "[PASS] max_log_file_action=keep_logs"; ((PASS++))
else echo "[FAIL] max_log_file_action != keep_logs"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
