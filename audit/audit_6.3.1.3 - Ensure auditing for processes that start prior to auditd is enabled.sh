#!/usr/bin/env bash
# CIS 6.3.1.3 - Ensure auditing for processes that start prior to auditd is enabled
PASS=0; FAIL=0
echo "=== CIS 6.3.1.3 - Ensure auditing for processes that start prior to auditd is enabled ==="
if grep -P '^\s*linux' /boot/grub2/grub.cfg | grep -vq 'audit=1'; then
echo "[FAIL] audit=1 missing from grub"; ((FAIL++))
else echo "[PASS] audit=1 present"; ((PASS++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
