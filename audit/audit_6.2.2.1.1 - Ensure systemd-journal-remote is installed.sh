#!/usr/bin/env bash
# CIS 6.2.2.1.1 - Ensure systemd-journal-remote is installed
PASS=0; FAIL=0
echo "=== CIS 6.2.2.1.1 - Ensure systemd-journal-remote is installed ==="
if rpm -q systemd-journal-remote >/dev/null 2>&1; then echo "[PASS] systemd-journal-remote is installed"; ((PASS++))
else echo "[FAIL] systemd-journal-remote is not installed"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
