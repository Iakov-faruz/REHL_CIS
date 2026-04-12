#!/usr/bin/env bash
# CIS 5.4.2.3 - Ensure group root is the only GID 0 group
PASS=0; FAIL=0
echo "=== CIS 5.4.2.3 - Ensure group root is the only GID 0 group ==="
if [ "$(awk -F: '$3=="0"{print $1}' /etc/group)" = "root" ]; then echo "[PASS] Only root group is GID 0"; ((PASS++))
else echo "[FAIL] Other groups have GID 0"; ((FAIL++)); fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
