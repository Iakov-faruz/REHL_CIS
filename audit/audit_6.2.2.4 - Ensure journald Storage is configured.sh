#!/usr/bin/env bash
# CIS 6.2.2.4 - Ensure journald Storage is configured
PASS=0; FAIL=0
echo "=== CIS 6.2.2.4 - Ensure journald Storage is configured ==="
if grep -Pqs '^\s*Storage\s*=\s*persistent' /etc/systemd/journald.conf /etc/systemd/journald.conf.d/*.conf; then
    echo "[PASS] Storage=persistent is configured"; ((PASS++))
else
    echo "[FAIL] Storage=persistent not found"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
