#!/usr/bin/env bash
# CIS 6.2.2.2 - Ensure journald ForwardToSyslog is disabled
PASS=0; FAIL=0
echo "=== CIS 6.2.2.2 - Ensure journald ForwardToSyslog is disabled ==="
if grep -Pqs '^\s*ForwardToSyslog\s*=\s*no' /etc/systemd/journald.conf /etc/systemd/journald.conf.d/*.conf; then
    echo "[PASS] ForwardToSyslog=no is configured"; ((PASS++))
else
    echo "[FAIL] ForwardToSyslog=no not found"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
