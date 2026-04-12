#!/usr/bin/env bash
# CIS 6.3.2.1 - Ensure audit log storage size is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.2.1 - Ensure audit log storage size is configured ==="
size=$(grep -Poi "^\s*max_log_file\s*=\s*\d+" /etc/audit/auditd.conf | awk -F= '{print $2}' | xargs)
if [ -n "$size" ] && [ "$size" -ge 8 ]; then echo "[PASS] max_log_file is $size"; ((PASS++))
else echo "[FAIL] max_log_file not >= 8"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
