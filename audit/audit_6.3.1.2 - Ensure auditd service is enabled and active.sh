#!/usr/bin/env bash
# CIS 6.3.1.2 - Ensure auditd service is enabled and active
PASS=0; FAIL=0
echo "=== CIS 6.3.1.2 - Ensure auditd service is enabled and active ==="
if systemctl is-enabled auditd | grep -q 'enabled' && systemctl is-active auditd | grep -q 'active'; then
echo "[PASS] auditd is enabled and active"; ((PASS++))
else echo "[FAIL] auditd is not enabled and active"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
