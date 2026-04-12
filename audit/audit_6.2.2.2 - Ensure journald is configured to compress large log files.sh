#!/usr/bin/env bash
# CIS 6.2.2.2 - Ensure journald is configured to compress large log files
PASS=0; FAIL=0
echo "=== CIS 6.2.2.2 - journald Compress ==="
if grep -Pqs '^\s*Compress\s*=\s*yes\b' /etc/systemd/journald.conf /etc/systemd/journald.conf.d/*.conf; then
    echo "[PASS] Compress=yes is configured"; ((PASS++))
else
    echo "[FAIL] Compress=yes not found"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
