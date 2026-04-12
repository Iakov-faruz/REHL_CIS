#!/usr/bin/env bash
# CIS 6.3.3.10 - Ensure audit rules for file system mounts are collected
PASS=0; FAIL=0
echo "=== CIS 6.3.3.10 - Ensure audit rules for file system mounts are collected ==="
if grep -Pq 'mounts' /etc/audit/rules.d/*.rules 2>/dev/null; then echo "[PASS] Rule found"; ((PASS++))
else echo "[FAIL] Rule missing"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
