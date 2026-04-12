#!/usr/bin/env bash
# CIS 7.1.3 - Ensure permissions on /etc/group are configured
PASS=0; FAIL=0
echo "=== CIS 7.1.3 - Ensure permissions on /etc/group are configured ==="
if [ ! -e "/etc/group" ]; then
    echo "[INFO] /etc/group does not exist"; exit 0
fi
actual=$(stat -Lc '%#a %U %G' "/etc/group")
read -r a_mode a_owner a_group <<< "$actual"
result_ok=0
[ "$a_owner" != "root" ] && { echo "[FAIL] /etc/group owner is $a_owner (expected root)"; ((FAIL++)); }
[ "$a_group" != "root" ] && { echo "[FAIL] /etc/group group is $a_group (expected root)"; ((FAIL++)); }

    if [ $(( $a_mode & 0133 )) -gt 0 ] 2>/dev/null; then
        echo "[FAIL] 7.1.3: /etc/group mode is $a_mode (should be 0644 or more restrictive)"; ((FAIL++))
    else
        result_ok=1
    fi
if [ "$result_ok" -eq 1 ] && [ "$FAIL" -eq 0 ]; then
    echo "[PASS] /etc/group permissions correct ($actual)"; ((PASS++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
