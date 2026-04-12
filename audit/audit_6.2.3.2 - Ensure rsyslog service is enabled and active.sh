#!/usr/bin/env bash
# CIS 6.2.3.2 - Ensure rsyslog service is enabled and active
PASS=0; FAIL=0
echo "=== CIS 6.2.3.2 - Ensure rsyslog service is enabled and active ==="
if systemctl is-enabled rsyslog 2>/dev/null | grep -q 'enabled' && systemctl is-active rsyslog 2>/dev/null | grep -q 'active'; then echo "[PASS] rsyslog is enabled and active"; ((PASS++))
else echo "[FAIL] rsyslog is not enabled and active"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
