#!/usr/bin/env bash
# CIS 1.8.5 - Ensure GDM screen locks cannot be overridden
# Remediation script for RHEL 9 / CIS Benchmark

{
    # Check if GDM is installed
    l_pkgoutput=""
    for l_pn in gdm gdm3; do
        rpm -q "$l_pn" > /dev/null 2>&1 && l_pkgoutput="y"
    done

    if [ -n "$l_pkgoutput" ]; then
        # Look for idle-delay to determine profile in use
        l_kfd="/etc/dconf/db/$(grep -Psril '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ 2>/dev/null | \
            awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"
        l_kfd2="/etc/dconf/db/$(grep -Psril '^\h*lock-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ 2>/dev/null | \
            awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"

        # Lock idle-delay setting
        if [ -d "$l_kfd" ]; then
            if grep -Prilq '/org/gnome/desktop/session/idle-delay\b' "$l_kfd" 2>/dev/null; then
                echo " - \"idle-delay\" is already locked in \"$(grep -Pril '/org/gnome/desktop/session/idle-delay\b' "$l_kfd")\""
            else
                echo " - creating entry to lock \"idle-delay\""
                [ ! -d "$l_kfd/locks" ] && echo "creating directory $l_kfd/locks" && mkdir "$l_kfd/locks"
                {
                    echo -e '\n# Lock desktop screensaver idle-delay setting'
                    echo '/org/gnome/desktop/session/idle-delay'
                } >> "$l_kfd/locks/00-screensaver"
            fi
        else
            echo " - \"idle-delay\" is not set so it cannot be locked"
            echo " - Please run fix_1.8.4 first and then run this script again"
        fi

        # Lock lock-delay setting
        if [ -d "$l_kfd2" ]; then
            if grep -Prilq '/org/gnome/desktop/screensaver/lock-delay\b' "$l_kfd2" 2>/dev/null; then
                echo " - \"lock-delay\" is already locked in \"$(grep -Pril '/org/gnome/desktop/screensaver/lock-delay\b' "$l_kfd2")\""
            else
                echo " - creating entry to lock \"lock-delay\""
                [ ! -d "$l_kfd2/locks" ] && echo "creating directory $l_kfd2/locks" && mkdir "$l_kfd2/locks"
                {
                    echo -e '\n# Lock desktop screensaver lock-delay setting'
                    echo '/org/gnome/desktop/screensaver/lock-delay'
                } >> "$l_kfd2/locks/00-screensaver"
            fi
        else
            echo " - \"lock-delay\" is not set so it cannot be locked"
            echo " - Please run fix_1.8.4 first and then run this script again"
        fi

        dconf update
        echo " - dconf database updated"
        echo " - NOTE: Users must log out and back in for changes to take effect"
    else
        echo " - GNOME Desktop Manager package is not installed - Recommendation is not applicable"
    fi
}

echo " - Done. GDM screen lock override prevention remediation complete."
