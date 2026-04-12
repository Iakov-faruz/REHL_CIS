#!/usr/bin/env bash
# CIS 7.1.6 - Ensure permissions on /etc/shadow- are configured
PASS=0; FAIL=0
echo "=== CIS 7.1.6 - Ensure permissions on /etc/shadow- are configured ==="
if [ ! -e "/etc/shadow-" ]; then
    echo "[INFO] /etc/shadow- does not exist"; exit 0
fi
actual=$(stat -Lc '%#a %U %G' "/etc/shadow-")
read -r a_mode a_owner a_group <<< "$actual"
result_ok=0
[ "$a_owner" != "root" ] && { echo "[FAIL] /etc/shadow- owner is $a_owner (expected root)"; ((FAIL++)); }
[ "$a_group" != "root" ] && { echo "[FAIL] /etc/shadow- group is $a_group (expected root)"; ((FAIL++)); }

    if [ "$a_mode" != "0" ] && [ "$a_mode" != "00" ] && [ "$a_mode" != "000" ] && [ "$a_mode" != "0000" ]; then
        echo "[FAIL] 7.1.6: /etc/shadow- mode is $a_mode (expected 0000)"; ((FAIL++))
    else
        result_ok=1
    fi
if [ "$result_ok" -eq 1 ] && [ "$FAIL" -eq 0 ]; then
    echo "[PASS] /etc/shadow- permissions correct ($actual)"; ((PASS++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
