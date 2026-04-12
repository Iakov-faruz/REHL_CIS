#!/usr/bin/env bash
# CIS 1.8.7 - Ensure GDM disabling automatic mounting of removable media is not overridden
# Remediation script for RHEL 9 / CIS Benchmark

{
    l_pkgoutput=""
    for l_pn in gdm gdm3; do
        rpm -q "$l_pn" > /dev/null 2>&1 && l_pkgoutput="y"
    done

    if [ -n "$l_pkgoutput" ]; then
        # Look for automount to determine profile in use
        l_kfd="/etc/dconf/db/$(grep -Psril '^\h*automount\b' /etc/dconf/db/*/ 2>/dev/null | \
            awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"
        l_kfd2="/etc/dconf/db/$(grep -Psril '^\h*automount-open\b' /etc/dconf/db/*/ 2>/dev/null | \
            awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"

        # Lock automount setting
        if [ -d "$l_kfd" ]; then
            if grep -Priq '^\h*\/org/gnome\/desktop\/media-handling\/automount\b' "$l_kfd" 2>/dev/null; then
                echo " - \"automount\" is already locked"
            else
                echo " - creating entry to lock \"automount\""
                [ ! -d "$l_kfd/locks" ] && mkdir "$l_kfd/locks"
                {
                    echo -e '\n# Lock desktop media-handling automount setting'
                    echo '/org/gnome/desktop/media-handling/automount'
                } >> "$l_kfd/locks/00-media-automount"
            fi
        else
            echo " - \"automount\" is not set so it cannot be locked"
            echo " - Please run fix_1.8.6 first and then run this script again"
        fi

        # Lock automount-open setting
        if [ -d "$l_kfd2" ]; then
            if grep -Priq '^\h*\/org/gnome\/desktop\/media-handling\/automount-open\b' "$l_kfd2" 2>/dev/null; then
                echo " - \"automount-open\" is already locked"
            else
                echo " - creating entry to lock \"automount-open\""
                [ ! -d "$l_kfd2/locks" ] && mkdir "$l_kfd2/locks"
                {
                    echo -e '\n# Lock desktop media-handling automount-open setting'
                    echo '/org/gnome/desktop/media-handling/automount-open'
                } >> "$l_kfd2/locks/00-media-automount"
            fi
        else
            echo " - \"automount-open\" is not set so it cannot be locked"
            echo " - Please run fix_1.8.6 first and then run this script again"
        fi

        dconf update
        echo " - dconf database updated"
    else
        echo " - GNOME Desktop Manager package is not installed - Recommendation is not applicable"
    fi
}

echo " - Done. GDM automount lock remediation complete."
