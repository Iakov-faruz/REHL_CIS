#!/usr/bin/env bash
# CIS 6.3.4.5 - Ensure audit configuration files mode is configured
PASS=0; FAIL=0
echo "=== CIS 6.3.4.5 - Audit Config Files Mode ==="
bad=$(find /etc/audit/ -type f \( -name "*.conf" -o -name '*.rules' \) -perm /0137 2>/dev/null)
if [ -z "$bad" ]; then
    echo "[PASS] All audit config files are mode 0640 or more restrictive"; ((PASS++))
else
    echo "[FAIL] Config files with excess permissions:"; echo "$bad"; ((FAIL++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
