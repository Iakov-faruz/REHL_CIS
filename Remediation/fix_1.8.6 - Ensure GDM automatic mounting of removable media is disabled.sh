#!/usr/bin/env bash
# CIS 1.8.6 - Ensure GDM automatic mounting of removable media is disabled
# Remediation script for RHEL 9 / CIS Benchmark

{
    l_pkgoutput=""
    l_gpname="local" # Set to desired dconf profile name (default is local)

    # Check if GDM is installed
    for l_pn in gdm gdm3; do
        rpm -q "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists"
        dpkg-query -W "$l_pn" > /dev/null 2>&1 && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists"
    done

    if [ -n "$l_pkgoutput" ]; then
        # Look for existing settings
        l_kfile="$(grep -Prils -- '^\h*automount\b' /etc/dconf/db/*.d 2>/dev/null)"
        l_kfile2="$(grep -Prils -- '^\h*automount-open\b' /etc/dconf/db/*.d 2>/dev/null)"

        # Set profile name based on dconf db directory if found
        if [ -f "$l_kfile" ]; then
            l_gpname="$(awk -F/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
        elif [ -f "$l_kfile2" ]; then
            l_gpname="$(awk -F/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile2")"
        fi

        [ -z "$l_kfile" ] && l_kfile="/etc/dconf/db/$l_gpname.d/00-media-automount"

        # Check if profile file exists
        if ! grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/* 2>/dev/null; then
            if [ ! -f "/etc/dconf/profile/user" ]; then
                l_gpfile="/etc/dconf/profile/user"
            else
                l_gpfile="/etc/dconf/profile/user2"
            fi
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

        # Check/set automount-open setting
        if grep -Pqs -- '^\h*automount-open\h*=\h*false\b' "$l_kfile" 2>/dev/null; then
            echo " - \"automount-open\" is already set to false in: \"$l_kfile\""
        else
            echo " - creating \"automount-open\" entry in \"$l_kfile\""
            ! grep -Psq -- '^\h*\[org\/gnome\/desktop\/media-handling\]' "$l_kfile" 2>/dev/null && \
                echo '[org/gnome/desktop/media-handling]' >> "$l_kfile"
            sed -ri '/^\s*\[org\/gnome\/desktop\/media-handling\]/a \\nautomount-open=false' "$l_kfile"
        fi

        # Check/set automount setting
        if grep -Pqs -- '^\h*automount\h*=\h*false\b' "$l_kfile" 2>/dev/null; then
            echo " - \"automount\" is already set to false in: \"$l_kfile\""
        else
            echo " - creating \"automount\" entry in \"$l_kfile\""
            ! grep -Psq -- '^\h*\[org\/gnome\/desktop\/media-handling\]' "$l_kfile" 2>/dev/null && \
                echo '[org/gnome/desktop/media-handling]' >> "$l_kfile"
            sed -ri '/^\s*\[org\/gnome\/desktop\/media-handling\]/a \\nautomount=false' "$l_kfile"
        fi

        dconf update
        echo " - Automount disabled. dconf database updated."
    else
        echo " - GNOME Desktop Manager package is not installed - Recommendation is not applicable"
    fi
}

echo " - Done. GDM automount disable remediation complete."
