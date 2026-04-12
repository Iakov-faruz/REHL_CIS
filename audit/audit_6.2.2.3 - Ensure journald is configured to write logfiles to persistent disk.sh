#!/usr/bin/env bash
# CIS 6.2.2.3 - Ensure journald is configured to write logfiles to persistent disk
PASS=0; FAIL=0
echo "=== CIS 6.2.2.3 - journald Storage ==="
if grep -Pqs '^\s*Storage\s*=\s*persistent\b' /etc/systemd/journald.conf /etc/systemd/journald.conf.d/*.conf; then
    echo "[PASS] Storage=persistent is configured"; ((PASS++))
else
    echo "[FAIL] Storage=persistent not found"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
