#!/usr/bin/env bash
# CIS 6.2.3.2 - Ensure rsyslog service is enabled
PASS=0; FAIL=0
echo "=== CIS 6.2.3.2 - rsyslog enabled ==="
if systemctl is-enabled rsyslog 2>/dev/null | grep -q 'enabled'; then
    echo "[PASS] rsyslog is enabled"; ((PASS++))
else
    echo "[FAIL] rsyslog is not enabled"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
