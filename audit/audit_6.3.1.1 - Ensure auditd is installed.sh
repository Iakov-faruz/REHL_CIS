#!/usr/bin/env bash
# CIS 6.3.1.1 - Ensure auditd is installed
PASS=0; FAIL=0
echo "=== CIS 6.3.1.1 - Ensure auditd is installed ==="
if rpm -q audit audit-libs >/dev/null 2>&1; then echo "[PASS] auditd is installed"; ((PASS++))
else echo "[FAIL] auditd is not installed"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
