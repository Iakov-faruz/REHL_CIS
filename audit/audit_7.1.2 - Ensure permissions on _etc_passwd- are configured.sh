#!/usr/bin/env bash
# CIS 7.1.2 - Ensure permissions on /etc/passwd- are configured
PASS=0; FAIL=0
echo "=== CIS 7.1.2 - Ensure permissions on /etc/passwd- are configured ==="
if [ ! -e "/etc/passwd-" ]; then
    echo "[INFO] /etc/passwd- does not exist"; exit 0
fi
actual=$(stat -Lc '%#a %U %G' "/etc/passwd-")
read -r a_mode a_owner a_group <<< "$actual"
result_ok=0
[ "$a_owner" != "root" ] && { echo "[FAIL] /etc/passwd- owner is $a_owner (expected root)"; ((FAIL++)); }
[ "$a_group" != "root" ] && { echo "[FAIL] /etc/passwd- group is $a_group (expected root)"; ((FAIL++)); }

    if [ $(( $a_mode & 0133 )) -gt 0 ] 2>/dev/null; then
        echo "[FAIL] 7.1.2: /etc/passwd- mode is $a_mode (should be 0644 or more restrictive)"; ((FAIL++))
    else
        result_ok=1
    fi
if [ "$result_ok" -eq 1 ] && [ "$FAIL" -eq 0 ]; then
    echo "[PASS] /etc/passwd- permissions correct ($actual)"; ((PASS++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
