#!/usr/bin/env bash
# CIS 6.3.4.6 - Ensure audit configuration files owner is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.6 - Audit Config Files Owner ==="
bad=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root 2>/dev/null)
if [ -z "$bad" ]; then
    echo "[PASS] All audit config files owned by root"; ((PASS++))
else
    echo "[FAIL] Config files not owned by root:"; echo "$bad"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
