#!/usr/bin/env bash
# CIS 6.2.2.1 - Ensure journald is configured to send logs to rsyslog
PASS=0; FAIL=0
echo "=== CIS 6.2.2.1 - journald ForwardToSyslog ==="
if grep -Pqs '^\s*ForwardToSyslog\s*=\s*yes\b' /etc/systemd/journald.conf /etc/systemd/journald.conf.d/*.conf; then
    echo "[PASS] ForwardToSyslog=yes is configured"; ((PASS++))
else
    echo "[FAIL] ForwardToSyslog=yes not found"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
