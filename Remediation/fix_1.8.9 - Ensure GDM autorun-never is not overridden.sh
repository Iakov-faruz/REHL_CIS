#!/usr/bin/env bash
# CIS 1.8.9 - Ensure GDM autorun-never is not overridden
# Remediation script for RHEL 9 / CIS Benchmark

{
    l_pkgoutput=""
    for l_pn in gdm gdm3; do
        rpm -q "$l_pn" > /dev/null 2>&1 && l_pkgoutput="y"
    done

    if [ -n "$l_pkgoutput" ]; then
        # Look for autorun to determine profile in use
        l_kfd="/etc/dconf/db/$(grep -Psril '^\h*autorun-never\b' /etc/dconf/db/*/ 2>/dev/null | \
            awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"

        if [ -d "$l_kfd" ]; then
            if grep -Priq '^\h*\/org/gnome\/desktop\/media-handling\/autorun-never\b' "$l_kfd" 2>/dev/null; then
                echo " - \"autorun-never\" is already locked"
            else
                echo " - creating entry to lock \"autorun-never\""
                [ ! -d "$l_kfd/locks" ] && mkdir "$l_kfd/locks"
                {
                    echo -e '\n# Lock desktop media-handling autorun-never setting'
                    echo '/org/gnome/desktop/media-handling/autorun-never'
                } >> "$l_kfd/locks/00-media-autorun"
            fi

            dconf update
            echo " - dconf database updated"
        else
            echo " - \"autorun-never\" is not set so it cannot be locked"
            echo " - Please run fix_1.8.8 first and then run this script again"
        fi
    else
        echo " - GNOME Desktop Manager package is not installed - Recommendation is not applicable"
    fi
}

echo " - Done. GDM autorun-never lock remediation complete."
