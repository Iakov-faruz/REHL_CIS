#!/usr/bin/env bash
# CIS 7.2.9 - Ensure local interactive user dot files access is configured
PASS=0; FAIL=0
echo "=== CIS 7.2.9 - Dot Files Access ==="
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
dot_fail=0
while read -r l_user l_home; do
    [ ! -d "$l_home" ] && continue
    for badfile in .forward .rhost; do
        [ -f "$l_home/$badfile" ] && { echo "[FAIL] $l_home/$badfile exists"; ((dot_fail++)); }
    done
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
[ "$dot_fail" -eq 0 ] && { echo "[PASS] No .forward or .rhost files found"; ((PASS++)); } || ((FAIL++))
echo "Results: PASS=$PASS | FAIL=$FAIL"
[ "$FAIL" -eq 0 ] && echo "** PASS **" || echo "** FAIL **"
