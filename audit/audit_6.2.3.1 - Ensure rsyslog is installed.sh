#!/usr/bin/env bash
# CIS 6.2.3.1 - Ensure rsyslog is installed
PASS=0; FAIL=0
echo "=== CIS 6.2.3.1 - Ensure rsyslog is installed ==="
if rpm -q rsyslog >/dev/null 2>&1; then echo "[PASS] rsyslog is installed"; ((PASS++))
else echo "[FAIL] rsyslog is not installed"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
