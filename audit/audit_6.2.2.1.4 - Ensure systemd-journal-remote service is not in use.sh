#!/usr/bin/env bash
# CIS 6.2.2.1.4 - Ensure systemd-journal-remote service is not in use
PASS=0; FAIL=0
echo "=== CIS 6.2.2.1.4 - Ensure systemd-journal-remote service is not in use ==="
if ! systemctl is-enabled systemd-journal-remote 2>/dev/null | grep -q 'enabled' && ! systemctl is-active systemd-journal-remote 2>/dev/null | grep -q 'active'; then
echo "[PASS] journal-remote is disabled"; ((PASS++))
else echo "[FAIL] journal-remote is enabled"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
