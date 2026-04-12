#!/usr/bin/env bash
# CIS 6.2.3.7 - Ensure rsyslog is not configured to receive logs from a remote client
PASS=0; FAIL=0
echo "=== CIS 6.2.3.7 - Ensure rsyslog is not configured to receive logs from a remote client ==="
bad=$(grep -Psq '^\s*\$ModLoad\s+imtcp|^\s*\$InputTCPServerRun' /etc/rsyslog.conf /etc/rsyslog.d/*.conf)
if [ -z "$bad" ]; then
    echo "[PASS] Remote reception is disabled"; ((PASS++))
else
    echo "[FAIL] Remote reception might be enabled"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
