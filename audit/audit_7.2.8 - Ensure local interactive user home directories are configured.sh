#!/usr/bin/env bash
# CIS 7.2.8 - Ensure local interactive user home directories are configured
PASS=0; FAIL=0
echo "=== CIS 7.2.8 - Home Directories ==="
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
home_fail=0
while read -r l_user l_home; do
    if [ -d "$l_home" ]; then
        l_own=$(stat -Lc '%U' "$l_home"); l_mode=$(stat -Lc '%#a' "$l_home")
        [ "$l_user" != "$l_own" ] && { echo "[FAIL] $l_home owned by $l_own (should be $l_user)"; ((home_fail++)); }
        if [ $(( $l_mode & 0027 )) -gt 0 ]; then echo "[FAIL] $l_home mode $l_mode (should be 0750 or more restrictive)"; ((home_fail++)); fi
    else
        [ "$l_home" != "/" ] && echo "[FAIL] User $l_user home $l_home does not exist" && ((home_fail++))
    fi
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
[ "$home_fail" -eq 0 ] && { echo "[PASS] All home directories properly configured"; ((PASS++)); } || ((FAIL++))
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
