#!/usr/bin/env bash
# CIS 7.1.7 - Ensure permissions on /etc/gshadow are configured
PASS=0; FAIL=0
echo "=== CIS 7.1.7 - Ensure permissions on /etc/gshadow are configured ==="
if [ ! -e "/etc/gshadow" ]; then
    echo "[INFO] /etc/gshadow does not exist"; exit 0
fi
actual=$(stat -Lc '%#a %U %G' "/etc/gshadow")
read -r a_mode a_owner a_group <<< "$actual"
result_ok=0
[ "$a_owner" != "root" ] && { echo "[FAIL] /etc/gshadow owner is $a_owner (expected root)"; ((FAIL++)); }
[ "$a_group" != "root" ] && { echo "[FAIL] /etc/gshadow group is $a_group (expected root)"; ((FAIL++)); }

    if [ "$a_mode" != "0" ] && [ "$a_mode" != "00" ] && [ "$a_mode" != "000" ] && [ "$a_mode" != "0000" ]; then
        echo "[FAIL] 7.1.7: /etc/gshadow mode is $a_mode (expected 0000)"; ((FAIL++))
    else
        result_ok=1
    fi
if [ "$result_ok" -eq 1 ] && [ "$FAIL" -eq 0 ]; then
    echo "[PASS] /etc/gshadow permissions correct ($actual)"; ((PASS++))
fi
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
