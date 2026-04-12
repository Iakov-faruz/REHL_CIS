#!/usr/bin/env bash
# CIS 6.2.2.1.3 - Ensure systemd-journal-upload is enabled and active
PASS=0; FAIL=0
echo "=== CIS 6.2.2.1.3 - Ensure systemd-journal-upload is enabled and active ==="
if systemctl is-enabled systemd-journal-upload | grep -q 'enabled' && systemctl is-active systemd-journal-upload | grep -q 'active'; then
echo "[PASS] journal-upload is enabled and active"; ((PASS++))
else echo "[FAIL] journal-upload is not enabled and active"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
