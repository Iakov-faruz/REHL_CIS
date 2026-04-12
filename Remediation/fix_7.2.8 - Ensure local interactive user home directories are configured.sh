#!/usr/bin/env bash
# CIS 7.2.8 - Ensure local interactive user home directories are configured
echo "=== CIS 7.2.8 - Fix Home Directories ==="
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
while read -r l_user l_home; do
    if [ -d "$l_home" ]; then
        l_own=$(stat -Lc '%U' "$l_home")
        [ "$l_user" != "$l_own" ] && { echo "[FIX] chown $l_user $l_home"; chown "$l_user" "$l_home"; }
        l_mode=$(stat -Lc '%#a' "$l_home")
        [ $(( $l_mode & 0027 )) -gt 0 ] && { echo "[FIX] chmod g-w,o-rwx $l_home"; chmod g-w,o-rwx "$l_home"; }
    fi
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
echo "[DONE] Home directories fixed"
