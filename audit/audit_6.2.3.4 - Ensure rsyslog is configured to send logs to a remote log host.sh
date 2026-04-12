#!/usr/bin/env bash
# CIS 6.2.3.4 - Ensure rsyslog is configured to send logs to a remote log host
PASS=0; FAIL=0
echo "=== CIS 6.2.3.4 - rsyslog remote host ==="
if grep -Pqs '^\s*\*\.\*\s+[^I][^I]*' /etc/rsyslog.conf /etc/rsyslog.d/*.conf | grep -Pq '@@|@'; then
    echo "[PASS] Remote logging configured"; ((PASS++))
else
    echo "[FAIL] Remote logging not configured"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
