#!/usr/bin/env bash
# CIS 6.3.1.4 - Ensure audit_backlog_limit is sufficient
PASS=0; FAIL=0
echo "=== CIS 6.3.1.4 - Ensure audit_backlog_limit is sufficient ==="
if grep -P '^\s*linux' /boot/grub2/grub.cfg | grep -vq 'audit_backlog_limit=8192'; then
echo "[FAIL] audit_backlog_limit=8192 missing from grub"; ((FAIL++))
else echo "[PASS] audit_backlog_limit present"; ((PASS++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
