#!/usr/bin/env bash
# CIS 7.2.9 - Ensure local interactive user dot files access is configured
echo "=== CIS 7.2.9 - Fix Dot Files ==="
l_valid_shells="^($( awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
while read -r l_user l_home; do
    [ ! -d "$l_home" ] && continue
    l_group="$(id -gn "$l_user" 2>/dev/null | xargs)"
    find "$l_home" -xdev -type f -name '.*' -print0 2>/dev/null | while IFS= read -r -d $'\0' f; do
        case "$(basename "$f")" in
            .forward|.rhost) echo "[WARN] $f exists - review and manually delete" ;;
            .bash_history) chmod u-x,go-rwx "$f"; chown "$l_user" "$f" ;;
            *) chmod u-x,go-wx "$f"; chown "$l_user" "$f"; [ -n "$l_group" ] && chgrp "$l_group" "$f" ;;
        esac
    done
done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"
echo "[DONE] Dot files access fixed"
