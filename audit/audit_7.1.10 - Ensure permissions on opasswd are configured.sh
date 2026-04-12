#!/usr/bin/env bash
# CIS 7.1.10 - Ensure permissions on /etc/security/opasswd are configured
PASS=0; FAIL=0
echo "=== CIS 7.1.10 - /etc/security/opasswd permissions ==="
for ofile in /etc/security/opasswd /etc/security/opasswd.old; do
    if [ -e "$ofile" ]; then
        o_info=$(stat -Lc '%#a %U %G' "$ofile")
        read -r o_mode o_owner o_group <<< "$o_info"
        if [ "$o_owner" = "root" ] && [ "$o_group" = "root" ] && [ $(( $o_mode & 0177 )) -eq 0 ]; then
            echo "[PASS] $ofile ($o_info)"; ((PASS++))
        else
            echo "[FAIL] $ofile ($o_info) - expected mode 0600, root:root"; ((FAIL++))
        fi
    fi
done
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
