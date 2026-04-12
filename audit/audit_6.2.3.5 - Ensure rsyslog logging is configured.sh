#!/usr/bin/env bash
# CIS 6.2.3.5 - Ensure rsyslog logging is configured
PASS=0; FAIL=0
echo "=== CIS 6.2.3.5 - Ensure rsyslog logging is configured ==="
if grep -Pqs '^\s*\*\.emerg' /etc/rsyslog.conf /etc/rsyslog.d/*.conf; then echo "[PASS] Configured rules found"; ((PASS++))
else echo "[FAIL] Configuration rules not found"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
