#!/usr/bin/env bash
# CIS Benchmark: 7.2.8-7.2.9 Remediation
# Fix home directory permissions and dot files
# Level: 1

echo "=============================================="
echo " CIS 7.2.8-7.2.9 - Fix Home Dirs and Dot Files"
echo "=============================================="

l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\/{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

while read -r l_user l_home; do
    if [ -d "$l_home" ]; then
        # Fix ownership
        l_own=$(stat -Lc '%U' "$l_home")
        if [ "$l_user" != "$l_own" ]; then
            echo "[FIX] Changing $l_home owner from $l_own to $l_user"
            chown "$l_user" "$l_home"
        fi
        # Fix permissions
        l_mode=$(stat -Lc '%#a' "$l_home")
        if [ $(( $l_mode & 0027 )) -gt 0 ]; then
            echo "[FIX] Fixing $l_home permissions ($l_mode -> 0750 or more restrictive)"
            chmod g-w,o-rwx "$l_home"
        fi
        # Fix dot files
        l_group="$(id -gn "$l_user" 2>/dev/null | xargs)"
        find "$l_home" -xdev -type f -name '.*' -print0 2>/dev/null | while IFS= read -r -d $'\0' l_hdfile; do
            case "$(basename "$l_hdfile")" in
                .forward | .rhost )
                    echo "[WARN] $l_hdfile exists - please review and manually delete"
                    ;;
                .bash_history )
                    chmod u-x,go-rwx "$l_hdfile" 2>/dev/null
                    chown "$l_user" "$l_hdfile" 2>/dev/null
                    ;;
                * )
                    chmod u-x,go-wx "$l_hdfile" 2>/dev/null
                    chown "$l_user" "$l_hdfile" 2>/dev/null
                    [ -n "$l_group" ] && chgrp "$l_group" "$l_hdfile" 2>/dev/null
                    ;;
            esac
        done
    else
        [ "$l_home" != "/" ] && echo "[WARN] User $l_user home $l_home does not exist - create or lock account"
    fi
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"

echo "[DONE] Home directories and dot files remediated."
echo "[NOTE] 7.2.4-7.2.7: Duplicate UIDs/GIDs/users/groups require manual investigation."
