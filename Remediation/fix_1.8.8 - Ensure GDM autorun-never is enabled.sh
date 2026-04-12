#!/usr/bin/env bash
# CIS 1.8.8 - Ensure GDM autorun-never is enabled
# Remediation script for RHEL 9 / CIS Benchmark

{
    l_pkgoutput=""
    l_gpname="local" # Set to desired dconf profile name (default is local)

    for l_pn in gdm gdm3; do
        rpm -q "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists"
    done

    if [ -n "$l_pkgoutput" ]; then
        # Look for existing autorun-never setting
        l_kfile="$(grep -Prils -- '^\h*autorun-never\b' /etc/dconf/db/*.d 2>/dev/null)"

        # Set profile name based on dconf db directory if found
        if [ -f "$l_kfile" ]; then
            l_gpname="$(awk -F/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
            echo " - updating dconf profile name to \"$l_gpname\""
        fi

        [ ! -f "$l_kfile" ] && l_kfile="/etc/dconf/db/$l_gpname.d/00-media-autorun"

        # Check if profile file exists
        if ! grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/* 2>/dev/null; then
            [ ! -f "/etc/dconf/profile/user" ] && l_gpfile="/etc/dconf/profile/user" || l_gpfile="/etc/dconf/profile/user2"
            echo " - creating dconf database profile"
            {
                echo -e "\nuser-db:user"
                echo "system-db:$l_gpname"
            } >> "$l_gpfile"
        fi

        # Create dconf directory if needed
        l_gpdir="/etc/dconf/db/$l_gpname.d"
        if [ ! -d "$l_gpdir" ]; then
            echo " - creating dconf database directory \"$l_gpdir\""
            mkdir "$l_gpdir"
        fi

        # Check/set autorun-never setting
        if grep -Pqs -- '^\h*autorun-never\h*=\h*true\b' "$l_kfile" 2>/dev/null; then
            echo " - \"autorun-never\" is already set to true in: \"$l_kfile\""
        else
            echo " - creating or updating \"autorun-never\" entry in \"$l_kfile\""
            if grep -Psq -- '^\h*autorun-never' "$l_kfile" 2>/dev/null; then
                sed -ri 's/(^\s*autorun-never\s*=\s*)(\S+)(\s*.*)$/\1true \3/' "$l_kfile"
            else
                ! grep -Psq -- '^\h*\[org\/gnome\/desktop\/media-handling\]' "$l_kfile" 2>/dev/null && \
                    echo '[org/gnome/desktop/media-handling]' >> "$l_kfile"
                sed -ri '/^\s*\[org\/gnome\/desktop\/media-handling\]/a \\nautorun-never=true' "$l_kfile"
            fi
            echo " - autorun-never set to true"
        fi

        dconf update
        echo " - dconf database updated"
    else
        echo " - GNOME Desktop Manager package is not installed - Recommendation is not applicable"
    fi
}

echo " - Done. GDM autorun-never remediation complete."
