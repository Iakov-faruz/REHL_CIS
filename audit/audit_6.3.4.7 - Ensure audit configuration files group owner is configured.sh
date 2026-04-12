#!/usr/bin/env bash
# CIS 6.3.4.7 - Ensure audit configuration files group owner is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.7 - Audit Config Files Group ==="
bad=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root 2>/dev/null)
if [ -z "$bad" ]; then
    echo "[PASS] All audit config files group owned by root"; ((PASS++))
else
    echo "[FAIL] Config files not group owned by root:"; echo "$bad"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
